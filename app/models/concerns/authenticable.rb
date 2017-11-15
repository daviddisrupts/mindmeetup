module Authenticable
	extend ActiveSupport::Concern

	def authenticated?
		unless confirmed? && !uid.present?
			errors.add(:email, :unconfirmed)
			return false
		end
		return true
	end
end