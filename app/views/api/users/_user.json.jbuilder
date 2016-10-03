json.extract! user, :id, :name, :activated
json.icon_url gravatar_for(user, url: true)
