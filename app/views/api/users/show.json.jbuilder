json.extract!(@user, :id, :display_name, :email, :created_at, :updated_at,
    :bio, :reputation, :location, :tags, :view_count, :vote_count, :avatar_url)

json.questions do
  json.array!(@questions) do |question|
    json.extract!(question, :id, :title, :created_at)
    json.favorite_count question.favorite_count_joins
    json.answer_count question.answer_count_joins
    json.view_count question.view_count_joins
    json.vote_count question.vote_count_joins
    json.tags question.tags_joins
  end
end

json.given_answers do
  json.array!(@given_answers) do |answer|
    json.extract!(answer, :id, :created_at, :question_id, :vote_count)
    json.title answer.question.title
  end
end

json.badges do
  json.array!(@badges) do |badge|
    json.extract!(badge, :id, :name, :rank, :description, :count, :category,
      :created_at)
  end
end

json.reputations do
  json.array!(@reputations) do |reputation|
    json.extract!(reputation, :id, :user_id, :votable_type, :votable_id,
        :reputation, :question_id, :title, :created_at)
  end
end

json.favorites do
  json.array!(@favorites) do |favorite|
    json.extract!(favorite, :id, :title, :created_at)
    json.favorite_count favorite.favorite_count_joins
    json.answer_count favorite.answer_count_joins
    json.view_count favorite.view_count_joins
    json.vote_count favorite.vote_count_joins
    json.tags favorite.tags_joins
  end
end

json.vote_stats @vote_stats

json.updated_at_words "last seen #{time_ago_in_words(@user.updated_at)} ago"
