# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  title      :string           not null
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Question < ActiveRecord::Base
  validates :user, :title, :content, presence: true
  # validate tag_ids?

  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :responders, -> { distinct }, through: :answers, source: :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings, source: :tag

  has_many :favorites
  has_many :favorite_users, through: :favorites, source: :user

  include Votable
  include Viewable

  def answer_count
    answers.length
  end

  def favorite_count
    favorites.length
  end

  # NOTE: ajax may eliminate the need for #add/remove_favorite on this model
  # TODO: remove user argument after implementing current_user
  def add_favorite(user)
    Favorite.create!(user: user, question: self)
  end

  # TODO: remove user argument after implementing current_user
  def remove_favorite(user)
    favorite = Favorite.find_by_user_id_and_question_id(user, id)
    if favorite
      favorite.destroy
    else
      debugger
      # TODO: handle favorite not found
    end
  end
end
