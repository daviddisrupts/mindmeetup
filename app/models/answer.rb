# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  question_id :integer          not null
#  content     :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  unread      :boolean          default(TRUE)
#
require 'elasticsearch/model'

class Answer < ActiveRecord::Base
  include Commentable
  include Votable
  include Searchable

  attr_accessor :matches

  validates :user_id, :question_id, :content, presence: true

  belongs_to :user
  belongs_to :question
  has_many :associated_tags, through: :question, source: :associated_tags
  has_many :tags, through: :question, source: :associated_tags

  def self.notifications_for_user_id(user_id)
    Answer.select("answers.*, questions.title, 'Answer' AS category")
      .joins(:question).where(questions: {user_id: user_id})
      .order(created_at: :desc)
  end

  # OPTIMIZE : Need to add title in qnswer object. Used in Api::SearchesController#query.
  def title
    question.title
  end
end
