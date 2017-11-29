class Api::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:update]

  def current
    if current_user
      @current_user = User.find_with_reputation(current_user.id)
      answers = Answer.notifications_for_user_id(current_user.id)
      comments = Comment.notifications_for_user_id(current_user.id)
      @notifications = (answers + comments).sort_by(&:created_at).reverse
    else
      render json: { id: nil }
    end
  end

  def create
    user = User.new(user_params)
      if user.save
        UserMailer.user_account_confirmation(user).deliver_now
        render json: { messages: [I18n.t("signup.success", email: user.email)] }, status: :ok
      else
        user_object = {
          id: nil,
          errors: user.errors.full_messages
        }
        render json: user_object, status: :unprocessable_entity
      end
  end

  def index
    @users = User.index_all
  end

  def show
    @user = User.show_find(params[:id])
    if @user
      @questions = Question.with_stats_and_tags_by_user_id(params[:id])
      @given_answers = Answer.includes(:votes, :question).where(user_id: params[:id])
      @badges = Badge.grouped_with_stats_by_user_id(params[:id])
      @reputations = Vote.reputations_for_user_id(params[:id])
      @vote_stats = Vote.stats_for_user_id(params[:id])
      @favorites = Favorite.questions_with_stats_and_tags_by_user_id(params[:id])
      View.create!(user: current_user, viewable: @user) if current_user
    else
      render json: {}, error: :not_found
    end
  end

  def update
    @user = User.find_with_reputation(params[:id])
    if @user.authorized?(user_params[:password])
      if @user.update(user_params)
        render_current_user
      else
        render json: @user.errors.full_messages, status: :unprocessable_entity
      end
    else
      render json: @user.errors.full_messages, status: :forbidden
    end
  end

  private

  def user_params
    allowed_params = [:avatar, :display_name, :bio, :location, :email]
    allowed_params.push(:password) unless @user && @user.social_login?
    params.require(:user).permit(allowed_params)
  end
end
