json.message "Created"
json.user do
  json.id @user.id
  json.name @user.name
  json.activated @user.activated
  json.icon_url gravatar_for(@user, url: true)
end
