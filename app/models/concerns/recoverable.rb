module Recoverable
  extend ActiveSupport::Concern
  include TokenGenerator

  module ClassMethods
    def send_reset_password_instructions(email)
      recoverable = find_or_initialize_with_errors(:email, email)
      recoverable.send_reset_password_instructions if recoverable.persisted?
      recoverable
    end

    def reset_password_by_token(attributes, token)
      recoverable = find_or_initialize_with_errors(:reset_password_token, token)
      recoverable.reset_password(attributes[:password], attributes[:password_confirmation]) if recoverable.persisted?
      recoverable
    end

    def find_or_initialize_with_errors(attribute, value)
      record = self.find_by("#{attribute} = (?)", value) || User.new()
      record.errors.add(attribute, :not_found) unless record.persisted?
      record
    end
  end

  def send_reset_password_instructions
    token = set_reset_password_token
    send_reset_password_instructions_notification(token)
    token
  end

  def reset_password(new_password, new_password_confirmation)
    if new_password.present? && new_password == new_password_confirmation
      self.password = new_password
      self.reset_password_token = nil
      self.reset_password_sent_at = nil
      save
    else
      if !new_password.present?
        errors.add(:password, :blank)
      else
        errors.add(:password, :not_match)
      end
      false
    end
  end

  protected

  def set_reset_password_token
    token = generate_token(self.class, :confirmation_token)
    self.reset_password_token = token
    self.reset_password_sent_at = Time.now.utc
    save(validate: false)
    token
  end

  def send_reset_password_instructions_notification(token)
    UserMailer.reset_password_instructions(self, token).deliver_now
  end

end