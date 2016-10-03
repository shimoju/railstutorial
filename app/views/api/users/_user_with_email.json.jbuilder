json.extract! user, :id, :name, :email, :activated
json.icon_url gravatar_for(user, url: true)
json.following_count user.following.count
json.followers_count user.followers.count
json.microposts_count user.microposts.count
