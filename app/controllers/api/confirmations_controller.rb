class Api::ConfirmationsController < ApplicationController
	def show
    resource = User.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      user_object = {
        message: 'Your email address has been successfully confirmed.'
      }
      render json: user_object, status: :ok
    else
    	user_object = {
        errors: resource.errors.full_messages
      }
      render json: user_object, status: :unprocessable_entity
    end
  end
end
