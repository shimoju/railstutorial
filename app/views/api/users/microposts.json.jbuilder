json.microposts do
  json.array!(@microposts) do |micropost|
    json.partial! "api/microposts/micropost", micropost: micropost
  end
end
