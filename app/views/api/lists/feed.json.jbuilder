json.feed do
  json.array!(@feed) do |micropost|
    json.partial! "api/microposts/micropost", micropost: micropost
  end
end
