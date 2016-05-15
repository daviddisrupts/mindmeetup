json.extract!(@current_user,
  :id, :display_name, :bio, :location, :reputation, :email
)

json.notifications @answers do |answer|
  json.extract!(answer, :id, :question_id, :title, :content, :created_at,
    :unread, :category)
end
