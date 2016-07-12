json.user do
  json.id @user.id
  json.name @user.name
  json.email @user.email
  json.icon_url gravatar_for(@user, url: true)
end

json.token @user.generate_jwt
