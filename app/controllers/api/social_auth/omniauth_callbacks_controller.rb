class Api::SocialAuth::OmniauthCallbacksController < ApplicationController

	def authenticate
		auth = request.env["omniauth.auth"]
		user = User.where(:provider => auth['provider'],
                      :uid => auth['uid'].to_s).first || User.create_with_omniauth(auth)

    login!(user)
    redirect_to '/#'
	end

	def failer
		current_user_object = {
      id: nil,
      errors: ["Authentication error: #{params[:message].humanize}"]
    }
    # render json: current_user_object, status: :unauthorized
    flash[:error] = "Authentication error: #{params[:message].humanize}"
    redirect_to '/#'
	end
end