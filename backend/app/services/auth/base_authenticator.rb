module Auth
  class BaseAuthenticator
    # ユーザーの認証を行う基底クラス
    def authenticate_user(user, password)
      # ユーザーが存在しない場合や、ログインが無効な場合はnilを返す
      return nil unless user
      return nil unless user.active_for_login?
      # パスワードが正しいか確認し、成功なら失敗回数をリセットしてユーザーを返す
      if user.authenticate(password)
        user.reset_failed_attempts!
        user
      else
        user.register_failed_attempt!
        nil
      end
    end
  end
end