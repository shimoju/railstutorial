json.followers do
  json.count @user.followers.count
  json.users do
    json.array! @users, :id, :name, :email
  end
end
