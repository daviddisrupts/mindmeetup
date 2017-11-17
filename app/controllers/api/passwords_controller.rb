class Api::PasswordsController < ApplicationController

  def create
    user = User.send_reset_password_instructions(params[:user][:email])
    if user.errors.empty?
      render json: { messages: ["Account recovery email sent to #{user.email}"] }, status: :ok
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    user = User.reset_password_by_token(params[:user], params[:reset_password_token])
    if user.errors.empty?
      render json: { message: ["Password successfully updated for #{user.email}. Try to sign in."] }, status: :ok
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end
  end
end
