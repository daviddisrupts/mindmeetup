require "rails_helper"

# NOTE: ::default_driver required (as opposed to ::current_driver) for more than
# one test to use selenium/javascript properly

Capybara.default_driver = :selenium
DatabaseCleaner.strategy = :truncation

feature "user authentication" do
  after(:all) { DatabaseCleaner.clean }
  before(:each) { visit("/") }

  feature "when first visit app" do
    scenario "user starts logged out and sees navbar links for authentication" do
      expect(page).to have_content "Log in"
      expect(page).to have_css "#nav-log-in"

      expect(page).to have_content "Sign up"
      expect(page).to have_css "#nav-sign-up"
    end

    scenario "user does not see authentication modal" do
      expect(page).to_not have_css ".authentication-modal"
      expect(page).to have_css "#nav-sign-up"
    end

  end

  feature "sign up process" do
    before(:each) { find("#nav-sign-up").click }

    scenario "user can expose a sign up form modal" do
      expect(page).to have_css ".authentication-modal"

      # proper input fields present
      within(".authentication-modal") do
        expect(page).to have_css "input#auth-email"
        expect(page).to have_css "input#auth-display-name"
        expect(page).to have_css "input#auth-password"
      end

      # proper submit button
      within(".authentication-modal button") do
        expect(page).to have_content "Sign up"
        expect(page).to_not have_content "Log in"
      end
    end

    feature "after accessing sign up modal" do
      feature "with proper user credentials" do
        scenario "user can sign up for an account and is then logged in" do
          within(".authentication-modal") do
            fill_in "auth-email", with: "test@user.com"
            fill_in "auth-display-name", with: "ZeroCool"
            fill_in "auth-password", with: "hunter2"
            find("button").click
          end

          expect(page).to_not have_content "Log in"
          expect(page).to_not have_css "#nav-log-in"
        end
      end

      feature "with invalid user credentials" do
        after(:each) do
          expect(page).to have_content "Log in"
          expect(page).to have_css "#nav-log-in"
          expect(page).to have_css ".auth-form-errors"
          within(".auth-form-errors") do
            expect(page).to have_content "Sign Up failed."
          end
        end

        feature "with blank email" do
          scenario "user can't sign up and sees relevant error msg" do
            within(".authentication-modal") do
              fill_in "auth-email", with: ""
              fill_in "auth-display-name", with: "ZeroCool"
              fill_in "auth-password", with: "hunter2"
              find("button").click
            end

            within(".auth-form-errors") do
              expect(page).to have_content "Email can't be blank."
            end
          end
        end

        feature "with email already registered" do
          scenario "user can't sign up and sees relevant error msg" do
            within(".authentication-modal") do
              fill_in "auth-email", with: "test@user.com"
              fill_in "auth-display-name", with: "ZeroCool"
              fill_in "auth-password", with: "hunter2"
              find("button").click
            end

            within(".auth-form-errors") do
              expect(page).to have_content "Email has already been taken."
            end
          end
        end

        feature "with blank display name" do
          scenario "user can't sign up and sees relevant error msg" do
            within(".authentication-modal") do
              fill_in "auth-email", with: "test@user.com"
              fill_in "auth-display-name", with: ""
              fill_in "auth-password", with: "hunter2"
              find("button").click
            end

            within(".auth-form-errors") do
              expect(page).to have_content "Display name can't be blank."
            end
          end
        end

        feature "with short password (<6 characters)" do
          scenario "user can't sign up and sees relevant error msg" do
            within(".authentication-modal") do
              fill_in "auth-email", with: "test@user.com"
              fill_in "auth-display-name", with: "ZeroCool"
              fill_in "auth-password", with: ""
              find("button").click
            end

            within(".auth-form-errors") do
              expect(page).to have_content "Password is too short (minimum is 6 characters)."
            end
          end
        end
      end

      scenario "user can switch to Log in mode" do
        within("#auth-submit") { expect(page).to have_content("Sign up") }
        within(".authentication-modal") { find("li", text: "Log In").click }
        within("#auth-submit") { expect(page).to have_content("Log in") }
      end
    end
  end
end
