module TokenGenerator

	protected

	def generate_token(klass, column, strength = 10)
  	loop do
  	 	token = SecureRandom.hex(strength)
  	 	break token unless klass.find_by("#{column} = (?)", token).present?
  	end
  end
end