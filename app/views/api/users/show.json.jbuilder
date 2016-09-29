json.user do
  json.partial! "user", user: @user
  json.following_count @user.following.count
  json.followers_count @user.followers.count
end
