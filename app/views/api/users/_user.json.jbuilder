json.extract! user, :id, :name, :email, :activated
json.icon_url gravatar_for(user, url: true)
