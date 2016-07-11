json.user do
  json.id @user.id
  json.name @user.name
  json.email @user.email
  json.activated @user.activated
  json.icon_url gravatar_for(@user, url: true)
  json.microposts @microposts
end

