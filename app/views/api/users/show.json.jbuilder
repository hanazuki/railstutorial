json.extract!(@user, :id, :name, :avatar_url)

json.followers_count(@user.followers.count)
json.following_count(@user.following.count)

json.microposts do
  json.array!(@microposts) do |micropost|
    json.partial! micropost
  end
end
