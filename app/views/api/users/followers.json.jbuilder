json.followers do
  json.count @user.followers.count
  json.users do
    json.array!(@users) do |user|
      json.partial! "user", user: user
    end
  end
end
