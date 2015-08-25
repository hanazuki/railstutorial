module UsersHelper
  def gravatar_for(user, options = {})
    size = options[:size] || 80
    gravatar_url = "#{user.avatar_url}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: 'gravatar')
  end
end
