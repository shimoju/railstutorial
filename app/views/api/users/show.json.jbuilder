json.user do
  json.partial! "user", user: @user
  json.microposts do
    json.array! @microposts, :content, :picture, :created_at 
  end
end
