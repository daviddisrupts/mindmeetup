class UserMailer < ApplicationMailer

  def user_account_confirmation(resource)
    @resource = resource
    mail(to: @resource.email, subject: 'Account created successfully.')
  end

  # Overrides same inside Devise::Mailer
  def confirmation_instructions(record, token, opts={})
    @current_user = opts[:current_user]
    super
  end

  # Overrides same inside Devise::Mailer
  def reset_password_instructions(record, token, opts={})
    super
  end

  # Overrides same inside Devise::Mailer
  def unlock_instructions(record, token, opts={})
    super
  end

  def contact_us(contact_params)
    @contact_params = contact_params
    mail(to: "support@myprobill.com", subject: 'Contact Us')
  end
end