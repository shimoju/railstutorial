json.members do
  json.array! @members do |member|
    json.partial! "api/users/user", user: member
  end
end
