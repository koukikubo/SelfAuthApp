module Authentication
  # Concernとして定義することで複数のControllerから共通利用できる
  extend ActiveSupport::Concern

  included do
    # ViewやControllerから current_user を呼べるようにする
    # API中心なら必須ではないが、将来的な拡張を考慮
    helper_method :current_user if respond_to?(:helper_method)
  end
  # ===============================
  # ログイン必須チェック
  # ===============================
  def require_login!
    # ログインしていれば処理を継続
    return if current_user
    # 未ログインの場合は401（認証エラー）
    # ここで処理を止めることでControllerの処理に入らせない
    render json: { error: "ログインが必要です" }, status: :unauthorized
  end

  # ===============================
  # 管理者権限チェック
  # ===============================
  def require_admin!
    # 管理者であれば処理を継続
    return if current_user.is_a?(Admin)
    return if user.is_a?(Staff) && user.owner?

    # スタッフ or 未ログインは403（権限エラー）
    # 401との違いを明確にしているのが重要
    render json: { error: "権限がありません" }, status: :forbidden
  end
end