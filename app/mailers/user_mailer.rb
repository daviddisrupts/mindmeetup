class UserMailer < ApplicationMailer

  def user_account_confirmation(resource)
    @resource = resource
    mail(to: @resource.email, subject: 'Account created successfully.')
  end

  def reset_password_instructions(resource, token)
    @resource = resource
    @token = token
    @url =  ApplicationMailer.default_url_options[:protocol] + ApplicationMailer.default_url_options[:host] + "/#/users/account-recovery?reset_password_token=#{@token}"
    mail(to: @resource.email, subject: 'Account Recovery - Snack Overflow')
  end

  def contact_to_admin(contact_details)
    @contact_details = contact_details
    mail(from: contact_details.email, to: "info@restartreality.com", subject: 'User contact you - Snack Overflow')
  end
end