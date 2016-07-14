json.user do
  json.extract! @user, :id, :name, :email, :activated
  json.icon_url gravatar_for(@user, url: true)
  json.microposts do
    json.array! @microposts, :content, :picture, :created_at 
  end
end

