json.following do
  json.count @user.following.count
  json.users do
    json.array! @users
  end
end
