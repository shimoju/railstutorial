json.message "Created"
json.user do
  json.partial! "user_with_email", user: @user
end
