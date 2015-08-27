json.extract!(micropost, :id, :user, :content, :created_at)

json.picture_url(micropost.picture.url)
