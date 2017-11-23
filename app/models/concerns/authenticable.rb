module Authenticable
  extend ActiveSupport::Concern
  AUTH_PROVIDER=['facebook', 'google_oauth2']

  def authenticated?
    unless confirmed? && !uid.present?
      errors.add(:email, :unconfirmed)
      return false
    end
    return true
  end

  def authorized?(password=nil)
    return self.social_login? || self.is_password?(password)
  end

  def social_login?
    social_login
  end

  private

  def social_login
    !!provider && !!uid && AUTH_PROVIDER.include?(self.provider)
  end

end