class BaseAuthenticator
  def authenticate_user(user, password)
    return nil unless user
    return nil unless user.active_for_login?

    if user.authenticate(password)
      user.reset_failed_attempts!
      user
    else
      user.register_failed_attempt!
      nil
    end
  end
end