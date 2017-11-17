class Api::PasswordsController < ApplicationController

  def create
    user = User.send_reset_password_instructions(params[:user][:email])
    if user.errors.empty?
      render json: { messages: ["Account recovery email sent to #{user.email}"] }, status: :ok
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def edit
    @recoverable_user = User.find_or_initialize_with_errors(:reset_password_token, params[:reset_password_token])
    if !@recoverable_user.errors.empty?
      user_object = {
        id: nil,
        errors: @recoverable_user.errors.full_messages,
        type: 'TOKEN_ERROR'
      }
      render json: user_object, status: :unprocessable_entity
    end
  end

  def update
    user = User.reset_password_by_token(password_params)
    if user.errors.empty?
      login!(user) && render_current_user
    else
      user_object = {
        id: nil,
        email: user.email,
        errors: user.errors.full_messages
      }
      render json: user_object, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :reset_password_token)
  end
end
