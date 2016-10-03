json.following do
  json.count @user.following.count
  json.users do
    json.array!(@users) do |user|
      json.partial! "user", user: user
    end
  end
end
