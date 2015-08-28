json.extract!(micropost, :id, :content, :created_at)

json.user do
  json.partial! micropost.user
end
json.picture_url(micropost.full_picture_url(request.protocol + request.host_with_port))
