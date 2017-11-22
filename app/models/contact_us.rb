class ContactUs
	include ActiveModel::Model
	attr_accessor :name, :email, :subject, :message

	validates :name, :email, :subject, :message, presence: true
end