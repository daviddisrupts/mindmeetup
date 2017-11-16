class Api::PasswordsController < ApplicationController

	def create
		user = User.send_reset_password_instructions(params[:user][:email])
    if user.errors.empty?
    	# current_user_object = {
     #    id: nil,
     #    messages: ["Account recovery email sent to #{user.email}"]
     #  }
    	# render json: current_user_object, status: :ok
    	render json: { messages: ["Account recovery email sent to #{user.email}"] }, status: :ok
    else
    	render json: user.errors.full_messages, status: :unprocessable_entity
    end
	end

	def update
		user = User.reset_password_by_token(params[:user][:reset_password_token])
		if user.errors.empty?
    	current_user_object = {
        id: nil,
        messages: ["Password successfully updated for #{user.email}. Try to sign in."]
      }
    	render json: current_user_object, status: :ok
    else
    	render json: user.errors.full_messages, status: :unprocessable_entity
    end
	end
end
