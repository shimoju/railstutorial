json.micropost do
  json.extract! @micropost, :id, :content, :picture, :created_at
end
