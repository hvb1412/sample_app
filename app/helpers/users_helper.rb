module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_for user, options = {size: Settings.gravatar.size}
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    options[:size]
    gravatar_url = "#{Settings.gravatar.url}/#{gravatar_id}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def can_destroy_user? user
    current_user.admin? && !current_user?(user)
  end
end
