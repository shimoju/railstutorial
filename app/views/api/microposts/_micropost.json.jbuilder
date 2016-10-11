json.extract! micropost, :id, :content, :user_id, :created_at
json.picture micropost.picture.url
json.user do
  json.partial! "api/users/user", user: micropost.user
end
