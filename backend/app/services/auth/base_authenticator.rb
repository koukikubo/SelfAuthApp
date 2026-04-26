module Auth
  class BaseAuthenticator
    def authenticate_user(user, password)
      return nil unless user
      # パスワードが正しいか確認し、成功なら失敗回数をリセットしてユーザーを返す
      unless user.authenticate(password)
        user.register_failed_attempt!
        return nil
      end

      # ユーザーがログイン可能な状態か確認する
      return nil unless user.active_for_login?
      user.reset_failed_attempts!
      user
    end
  end
end