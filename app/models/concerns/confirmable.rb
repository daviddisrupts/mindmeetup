module Confirmable
  extend ActiveSupport::Concern

  included do
    before_create :generate_confirmation_token
  end

  def generate_confirmation_token
  	if self.confirmation_token && !confirmation_period_expired?
      @raw_confirmation_token = self.confirmation_token
    else
      self.confirmation_token = @raw_confirmation_token = generate_token
      self.confirmation_sent_at = Time.now.utc
    end
  end

  def generate_confirmation_token!
    generate_confirmation_token && save(validate: false)
  end

  def confirm_by_token(confirmation_token)
    confirmable = find_by(confirmation_token: confirmation_token)
    unless confirmable
      confirmation_digest = Devise.token_generator.digest(self, :confirmation_token, confirmation_token)
      confirmable = find_or_initialize_with_error_by(:confirmation_token, confirmation_digest)
    end

    confirmable.confirm if confirmable.persisted?
    confirmable
  end

  def confirm
  	if confirmation_period_expired?
      self.errors.add(:email, :confirmation_period_expired)
      return false
    end
  	self.confirmed_at = Time.now.utc
  	save(validate: true)
  end

  protected

  def confirmation_period_expired?
    Time.now.utc > self.confirmation_sent_at.utc + eval(ENV['USER_CONFIRM_WITHIN'])
  end

  def generate_token
  	loop do
  	 	token = SecureRandom.hex(10)
  	 	break token unless User.where(confirmation_token: token).exists?
  	end
  end

end