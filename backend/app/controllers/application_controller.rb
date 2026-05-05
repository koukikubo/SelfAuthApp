class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from AuthorizationError, with: :render_forbidden
  rescue_from BusinessError, with: :render_unprocessable_entity
  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid

  
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

    Rails.logger.debug("user_id=#{user&.id}, type=#{user&.class}")    
    Rails.logger.debug("active_for_login?=#{user&.active_for_login?}")

    # 有効かどうかをチェック
    unless user&.active_for_login?
      Rails.logger.debug("ログイン無効でreset_session")
      return nil
    end
    # 無操作か確認
    return nil unless check_timeout

    user
  end
  # 権限チェック
  def require_owner_or_admin!
    user = current_user

    return if user.is_a?(Admin)
    return if user.is_a?(Staff) && user.owner?

    render json: { error: "権限がありません" }, status: :forbidden
  end

  def check_timeout
    return true unless session[:last_access_at]

    if session[:last_access_at] < TIMEOUT.ago
      reset_session
      return false
    end
    # OKの場合は、更新
    session[:last_access_at] = Time.current
    true
  end


  # エラー処理
  def render_not_found(error)
    render json: { error: error.message }, status: :not_found
  end

  def render_forbidden(error)
    render json: { error: error.message }, status: :forbidden
  end

  def render_unprocessable_entity(error)
    render json: { error: error.message }, status: :unprocessable_entity
  end

  def render_record_invalid(error)
    render json: { error: error.record.errors.full_messages }, status: :unprocessable_entity
  end

  rescue_from AuthorizationError do |e|
    render json: { error: e.message }, status: :forbidden
  end

  rescue_from BusinessError do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
