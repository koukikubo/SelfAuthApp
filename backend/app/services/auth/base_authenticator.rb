module Auth
  class BaseAuthenticator
    # ユーザーの認証を行う基底クラス
    def authenticate_user(user, password)
      # ユーザーが存在しない場合や、ログインが無効な場合はnilを返す
      return nil unless user
      # パスワードが正しいか確認し、成功なら失敗回数をリセットしてユーザーを返す
      unless user.authenticate(password)
        user.register_failed_attempt!
        return nil
      end
      # ログイン成功した場合は失敗回数をリセットする
      user.reset_failed_attempts!
      # ユーザーがログイン可能な状態か確認する
      return nil unless user.active_for_login?
      user
    end
  end
end