class Api::ConfirmationsController < ApplicationController
	def show
    resource = User.confirm_by_token(params[:confirmation_token])

    unless resource
	    flash[:error] = t('activerecord.errors.models.user.attributes.confirmation_token.not_found')
	    return redirect_to root_path
	  end

    if resource.errors.empty?
      redirect_to root_path, notice: t('activerecord.success.models.user.attributes.email.confirmed')
    else
     flash[:error]=resource.errors.full_messages.join(',')
     redirect_to root_path
    end
  end
end
