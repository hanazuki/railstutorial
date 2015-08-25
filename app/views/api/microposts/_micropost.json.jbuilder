json.extract!(micropost, :id, :user_id, :content, :created_at)

json.picture_url(micropost.picture.url)
