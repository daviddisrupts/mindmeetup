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

  def confirm
  	if confirmation_period_expired?
      self.errors.add(:confirmation_token, :confirmation_period_expired)
      return false
    end
  	self.confirmed_at = Time.now.utc
  	save(validate: true)
  end

  def confirmed?
    !!confirmed_at
  end

  def unconfirmed?
    !confirmed_at
  end

  module ClassMethods
  	def confirm_by_token(confirmation_token)
	    confirmable = find_by(confirmation_token: confirmation_token)
	    unless confirmable
	      return false
	    end

	    confirmable.errors.add(:email, :already_confirmed) if confirmable.confirmed?
	    confirmable.confirm if confirmable.unconfirmed? && confirmable.persisted?
	    confirmable
	  end
  end

  protected

  def confirmation_period_expired?
    Time.now.utc > self.confirmation_sent_at.utc + eval(ENV['USER_CONFIRM_WITHIN'] || '15.days')
  end

  def generate_token
  	loop do
  	 	token = SecureRandom.hex(10)
  	 	break token unless User.where(confirmation_token: token).exists?
  	end
  end

end