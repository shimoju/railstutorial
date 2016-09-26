json.followers do
  json.count @user.followers.count
  json.users do
    json.array! @users
  end
end
