require "rails_helper"

Capybara.default_driver = :selenium
DatabaseCleaner.strategy = :truncation

feature "question creation" do
  after(:all) { DatabaseCleaner.clean }

  # NOTE: should visit questions/ask or appropriate
  before(:each) { visit("/#/ask") }

  feature "question creation form" do
    scenario "has submission button and text inputs for question title, body, tags" do
      expect(page).to have_css "input#question-form-title-input"
      expect(page).to have_css "textarea#item-content-input"
      expect(page).to have_css "input#question-form-tags-input"

      expect(page).to have_css ".question-form-main button"
    end
  end

  feature "for non-logged in users" do
    scenario "valid question creation submission user triggers auth modal popup" do
      # auth modal initially not visible
      expect(page).not_to have_css ".authentication-modal"

      within(".question-form-main") do
        fill_in "question-form-title-input", with: "question title test"
        fill_in "item-content-input", with: "question content test"
        find("button").click
      end

      expect(page).to have_css ".authentication-modal"
    end
  end

  feature "for authenticated users" do
    include AuthHelper

    before(:all) do
      create_test_user
    end

    before(:each) do
      login_test_user
      visit("/#/ask")
    end

    feature "invalid question creation" do
      scenario "with no title, submission button is disabled" do
        within(".question-form-main") do
          fill_in "item-content-input", with: "question content test"
          find("button").click
          expect(find("button")[:class].include?("button-disabled")).to be true
        end

        # expect to remain on same page and not be redirected to newly built question
        expect(page).to have_css ".question-form-main"
      end

      scenario "with no content, submission button is disabled" do
        within(".question-form-main") do
          fill_in "question-form-title-input", with: "question title test"
          find("button").click
          expect(find("button")[:class].include?("button-disabled")).to be true
        end

        # TODO: add more user feedback to show question creation failed
        expect(page).to have_css ".question-form-main"
      end
    end

    feature "tagging" do
      before(:all) do
        create(:tag, name: "test-tag", description: "I am a test tag")
        create(:tag, name: "super-tag", description: "I am another test tag")
        create(:tag, name: "pizza", description: "best food")
        create(:tag, name: "grass", description: "good for herbivores")
        create(:tag, name: "rocks", description: "full of minerals")
        create(:tag, name: "condiments", description: "ketchup, et al.")
        create(:tag, name: "space-food", description: "food in space!!!")
      end

      # before(:each) do
      #   within(".question-form-main") do
      #     fill_in "question-form-title-input", with: "tagging question title test"
      #     fill_in "item-content-input", with: "tagging question content test"
      #   end
      # end

      feature "querying" do
        scenario "when tagging input is empty, tag selection popout is absent" do
          expect(page).not_to have_css(".question-form-tags-search-popout")
        end

        scenario "typing fragment of existing tags pops up matching tags" do
          within(".question-form-main") do
            fill_in "question-form-tags-input", with: "-ta"
          end

          expect(page).to have_css(".question-form-tags-search-popout")
          within(".question-form-tags-search-popout") do
            expect(page).to have_css(".found-tag-item", count: 2)
            expect(page).to have_css(".found-tag-name", text: "test-tag")
            expect(page).to have_css(".found-tag-description", text: "I am a test tag")
            expect(page).to have_css(".found-tag-name", text: "super-tag")
            expect(page).to have_css(".found-tag-description", text: "I am another test tag")
          end
        end

        scenario "typing fragment specific to single tag pops up that single tag" do
          within(".question-form-main") do
            fill_in "question-form-tags-input", with: "test-ta"
          end

          expect(page).to have_css(".question-form-tags-search-popout")
          within(".question-form-tags-search-popout") do
            expect(page).to have_css(".found-tag-item", count: 1)
            expect(page).to have_css(".found-tag-name", text: "test-tag")
            expect(page).to have_css(".found-tag-description", text: "I am a test tag")
          end
        end
      end

      feature "selecting/deselecting" do
        scenario "new question form starts without any tags selected" do
          within(".question-form-main") do
            expect(page).not_to have_css(".removable-tag-stub-container")
          end
        end

        scenario "clicking on tag popup adds tag to question's current tags" do
          within(".question-form-main") do
            fill_in "question-form-tags-input", with: "test-ta"
            find(".found-tag-name", text: "test-tag").click
            expect(page).to have_css(".removable-tag-stub-container", text: "test-tag")
          end
        end

        scenario "typing in full tag name and pressing enter adds tag to question's current tags" do
          within(".question-form-main") do
            fill_in "question-form-tags-input", with: "test-tag"
            find("#question-form-tags-input").native.send_keys(:return)
            expect(page).to have_css(".removable-tag-stub-container", text: "test-tag")
          end
        end

        scenario "can only add up to 5 tags" do
          within(".question-form-main") do
            # input starts enabled
            expect(find("#question-form-tags-input")).not_to be_disabled

            5.times do
              fill_in "question-form-tags-input", with: "a"
              first(".found-tag-name").click
            end
            expect(page).to have_css(".removable-tag-stub-container", count: 5)
            expect(find("#question-form-tags-input")).to be_disabled
            expect(find("#question-form-tags-input")['placeholder']).to eq("5 tags max.")
          end
        end

        let(:removable_tag_stub_container_for_test_tag) do
          # xpath to find element's parent
          find(".removable-tag-stub-name", text: "test-tag").find(:xpath, '..')
        end

        scenario "user can undo tagging of a question by clicking corresponding tag 'x'" do
          within(".question-form-main") do
            fill_in "question-form-tags-input", with: "test-tag"
            find("#question-form-tags-input").native.send_keys(:return)
            fill_in "question-form-tags-input", with: "super-tag"
            find("#question-form-tags-input").native.send_keys(:return)

            expect(page).to have_css(".removable-tag-stub-container", count: 2)
            expect(page).to have_css(".removable-tag-stub-container", text: "test-tag")
            expect(page).to have_css(".removable-tag-stub-container", text: "super-tag")

            # click x to delete "test-tag" tag
            within removable_tag_stub_container_for_test_tag do
              find(".removable-tag-stub-cancel").click
            end

            # only the desired tag is removed
            expect(page).to have_css(".removable-tag-stub-container", count: 1)
            expect(page).not_to have_css(".removable-tag-stub-container", text: "test-tag")
            expect(page).to have_css(".removable-tag-stub-container", text: "super-tag")
          end
        end

        scenario "user cannot tag question with same tag" do
          within(".question-form-main") do
            # add tag "test-tag"
            fill_in "question-form-tags-input", with: "test-tag"
            expect(page).to have_css(".found-tag-name", text: "test-tag")
            find("#question-form-tags-input").native.send_keys(:return)
            expect(page).to have_css(".removable-tag-stub-container", text: "test-tag")

            # attempt to add same tag "test-tag"
            fill_in "question-form-tags-input", with: "test-tag"

            # tag should now not be present in popout, so can't click to add it
            expect(page).not_to have_css(".found-tag-name", text: "test-tag")

            # pressing keyboard :enter: on exact tag name should not add tag either
            find("#question-form-tags-input").native.send_keys(:return)

            expect(page).to have_css(".removable-tag-stub-container", count: 1)
          end
        end
      end

      feature "creation" do
        scenario "user can create tags" do
          raise "prevent non-logged in users from accessing tag input first (pop out auth modal)"
        end
      end
    end

    feature "valid question creation" do
      before(:all) { create(:tag, name: "test-tag", description: "I am a test tag") }
      before(:each) do
        within(".question-form-main") do
          fill_in "question-form-title-input", with: "question title test"
          fill_in "item-content-input", with: "question content test"
        end
      end

      scenario "user can create question with valid title and body and no tags" do
        within(".question-form-main") do
          expect(find("button")[:class].include?("button-disabled")).to be false
          find("button").click
        end

        # expect to see question show page of newly created question
        expect(page).to have_css(".question-show")
        within(".question-show") do
          expect(find(".question-show-header")).to have_content "question title test"
          expect(find(".question-show-item-main-content")).to have_content "question content test"
        end
      end

      scenario "user can create question with valid title, body, and tags" do
        within(".question-form-main") do
          fill_in "question-form-tags-input", with: "test-tag"
          find("#question-form-tags-input").native.send_keys(:return)

          expect(find("button")[:class].include?("button-disabled")).to be false
          find("button").click
        end

        # expect to see question show page of newly created question
        expect(page).to have_css(".question-show")
        within(".question-show") do
          expect(find(".question-show-header")).to have_content "question title test"
          expect(find(".question-show-item-main-content")).to have_content "question content test"
          expect(find(".question-show-item-tags-container")).to have_content "test-tag"
        end
      end
    end
  end
end

feature "question editing" do

end

feature "question deletion" do

end
