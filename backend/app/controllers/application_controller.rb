class ApplicationController < ActionController::Base
  # セッション保持時間を１時間に設定
  TIMEOUT = 60.minutes
  # 認証ロジックの共通化
  include Authentication
  # 全てのコントローラーでセッションを使用できるようにする
  include ActionController::Cookies
  # CSRF対策
  protect_from_forgery with: :exception

  private
  
  def current_user
    user = if session[:admin_id]
      # DBを確認
      Admin.find_by(id: session[:admin_id])
    elsif session[:staff_id]
      Staff.find_by(id: session[:staff_id])
    end
    # 有効かどうかをチェック
    unless user&.active_for_login?
      reset_session
      return nil
    end
    無操作か確認
    return nil unless check_timeout

    user
  end
  # 権限チェック
  def require_owner_or_admin!
    # AdminならOK
    return if current_admin

    # 機能制限を権限で決める
    return if current_staff&.owner?

    render json: { error: "権限がありません" }, status: :forbidden
  end

  def check_timeout
    return unless session[:last_access_at]

    if session[:last_access_at] < TIMEOUT.ago
      reset_session
      return false
    end
    # OKの場合は、更新
    session[:last_access_at] = Time.current
    true
  end
end
