json.extract!(micropost, :id, :content, :created_at)

json.user do
  json.partial! micropost.user
end
json.picture_url(micropost.picture.url)
