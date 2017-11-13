class Api::SessionsController < ApplicationController
  def create
    user = User.find_by_credentials(
      params[:user][:email], params[:user][:password]
    )
    if user
      return render json: {
        id: nil,
        errors: user.errors.full_messages
      }, status: :unauthorized unless user.authenticated?
    login!(user) && render_current_user
    else
      current_user_object = {
        id: nil,
        errors: ['No user found with these credentials. Please try again']
      }
      render json: current_user_object, status: :unauthorized
    end

  end

  def destroy
    logout!
    render json: { id: nil }
  end
end
