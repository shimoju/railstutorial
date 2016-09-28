json.user do
  json.partial! "user", user: @user
  json.following_count @user.following.count
  json.followers_count @user.followers.count
  json.microposts do
    json.array! @microposts, :content, :picture, :created_at 
  end
end
