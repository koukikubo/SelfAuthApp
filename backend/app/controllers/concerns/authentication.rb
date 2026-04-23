module Authentication
  # Concernとして定義することで複数のControllerから共通利用できる
  extend ActiveSupport::Concern

  included do
    # ViewやControllerから current_user を呼べるようにする
    # API中心なら必須ではないが、将来的な拡張を考慮
    helper_method :current_user if respond_to?(:helper_method)
  end

  # ===============================
  # 現在ログインしている管理者を取得
  # ===============================
  def current_admin
    # ||= によりメモ化（同一リクエスト内でDBアクセスを1回に抑える）
    # find_by を使うことでレコードが存在しない場合でも例外にならず nil を返す
    @current_admin ||= Admin.find_by(id: session[:admin_id])
  end

  # ===============================
  # 現在ログインしているスタッフを取得
  # ===============================
  def current_staff
    # adminと同様にメモ化 + nil安全
    @current_staff ||= Staff.find_by(id: session[:staff_id])
  end

  # ===============================
  # 現在ログインしているユーザーを取得（共通化）
  # ===============================
  def current_user_type
    # 管理者が優先されるように順番を工夫
    return :admin if current_admin
    # スタッフが存在すればスタッフ、それ以外は nil を返す
    return :staff if current_staff
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
    return if current_admin

    # スタッフ or 未ログインは403（権限エラー）
    # 401との違いを明確にしているのが重要
    render json: { error: "権限がありません" }, status: :forbidden
  end
end