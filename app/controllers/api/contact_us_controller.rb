class Api::ContactUsController < ApplicationController

	def create
		contact_us = ContactUs.new(contact_us_params)
		if contact_us.valid?
			UserMailer.contact_to_admin(contact_us).deliver
			render json: { messages: [I18n.t("contact_us.send.success")] }, status: :ok
		else
			render json: contact_us.errors.full_messages, status: :unprocessable_entity
		end
	end

	private

	def contact_us_params
		params.require(:contact_us).permit(:name, :email, :subject, :message)
	end

end