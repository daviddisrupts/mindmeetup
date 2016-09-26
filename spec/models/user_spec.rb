# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  display_name    :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  bio             :text
#  location        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  let(:user) { build(:user) }

  describe "ActiveModel validations" do
    # Basic validations
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:display_name) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_presence_of(:session_token) }

    # NOTE: TODO: email uniqueness should NOT be case sensitive. add before_save
    # (and before_update ??) callback on user model to #downcase email string!
    it { expect(user).to validate_uniqueness_of(:email) }

    it { expect(user).to validate_uniqueness_of(:session_token) }

    # Format validations
    # TODO: add email format validations
    # it { expect(user).to allow_value("dhh@nonopinionated.com").for(:email) }
    # it { expect(user).to_not allow_value("base@example").for(:email) }
    # it { expect(user).to_not allow_value("blah").for(:email) }

    # Inclusion/acceptance of values
    it { should allow_value(nil).for(:password) }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe "ActiveRecord associations" do
    # Associations
    it { should have_many :questions }
    it { should have_many :given_answers }
    it { should have_many :comments }
    it { should have_many :views }
  end

  describe "public instance methods" do
    context "responds to its methods" do
      it { expect(user).to respond_to(:password=) }
      it { expect(user).to respond_to(:password) }
      it { expect(user).to respond_to(:is_password?) }
      it { expect(user).to respond_to(:reset_session_token!) }
      it { expect(user).to respond_to(:to_s) }
    end

    context "executes methods correctly" do
      describe "#password=" do
        let(:user) { build(:user, password_digest: nil) }
        let(:password_digest) { BCrypt::Password.create("hunter2") }
        let(:saved_pw_digest) { BCrypt::Password.new(user.password_digest) }

        it "sets #password_digest to BCrypt hashed password" do
          user.password = "hunter2"
          expect(saved_pw_digest.is_password?("hunter2")).to be true
        end
      end

      describe "#is_password?" do
        context "with correct password" do
          it "returns true" do
            expect(user.is_password?("password")).to be true
          end
        end

        context "with incorrect password" do
          it "returns false" do
            expect(user.is_password?("passw0rd")).to be false
          end
        end
      end

      describe "#reset_session_token!" do
        context "resets #session_token to a" do
          it "string 22 characters long" do
            user.reset_session_token!
            expect(user.session_token.length).to eq(22)
          end

          it "different string" do
            old_session_token = user.session_token
            user.reset_session_token!
            expect(user.session_token).to_not eq(old_session_token)
          end
        end

        it "returns the user's new session token" do
          expect(user.reset_session_token!).to eq(user.session_token)
        end
      end

      describe "#to_s" do
        it "returns the user's display name" do
          expect(user.to_s).to eq(user.display_name)
        end
      end
    end
  end

  # TODO: add User.find_with_reputation_and_tags_and_vote_count, etc.
  describe "public class methods" do
    context "responds to its methods" do
      it { expect(User).to respond_to(:find_by_credentials) }
    end

    context "executes methods correctly" do
      describe "self.find_by_credentials" do
        let!(:user) do
          User.create(
            email: 'foo@example.com',
            password: 'hunter2',
            display_name: 'zerocool'
          )
        end

        context "with valid user credentials" do
          it "returns the found user" do
            expect(User.find_by_credentials('foo@example.com', 'hunter2')).
              to eq(user)
          end
        end

        context "with invalid credentials" do
          context "wrong password, valid email" do
            it "returns nil" do
              expect(User.find_by_credentials('foo@example.com', 'hunter3')).
                to be nil
            end
          end

          context "wrong email, valid password" do
            it "returns nil" do
              expect(User.find_by_credentials('fo0@example.com', 'hunter2')).
                to be nil
            end
          end

          context "invalid email and password" do
            it "returns nil" do
              expect(User.find_by_credentials('fo0@example.com', 'hunter3')).
                to be nil
            end
          end
        end
      end
    end
  end
end