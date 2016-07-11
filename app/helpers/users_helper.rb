module UsersHelper
  def gravatar_for(user, size: 80, url: false)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    if url
      return gravatar_url
    else
      return image_tag(gravatar_url, alt: user.name, class: "gravatar")
    end
  end

end
