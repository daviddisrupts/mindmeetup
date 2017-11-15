# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

	def user_account_confirmation
    UserMailer.user_account_confirmation(User.first)
  end

end
