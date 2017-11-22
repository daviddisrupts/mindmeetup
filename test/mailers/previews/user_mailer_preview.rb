# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def user_account_confirmation
    UserMailer.user_account_confirmation(User.first)
  end

  def contact_to_admin
    contact_us = ContactUs.new(name: "User1", email: "user1@gmail.com", subject: "hello123", message: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
        tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
        quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
        consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
        cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
        proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
    UserMailer.contact_to_admin(contact_us)
  end

end
