json.user do
  json.partial! "user", user: @user
  json.email @user.email
  json.following_count @user.following.count
  json.followers_count @user.followers.count
  json.microposts_count @user.microposts.count
end
