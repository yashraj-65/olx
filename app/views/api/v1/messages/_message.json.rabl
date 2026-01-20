attributes :id, :body, :conversation_id, :user_id, :created_at

child :user do
  attributes :id, :name, :email
end