json.token @user.generate_jwt
json.user do
  json.partial! "api/users/user_with_email", user: @user
end
