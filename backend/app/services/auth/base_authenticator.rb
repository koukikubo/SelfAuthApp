module Auth
  class BaseAuthenticator
    def authenticate_user(user, password)
      return :not_found unless user

      unless user.authenticate(password)
        return :invalid_password
      end

      return :inactive unless user.active_for_login?

      :success
    end
  end
end