class Api::V1::AdminSessionsController < ApplicationController
  def create
    result = Auth::Admin::AdminAuthenticator.new(
      params[:id], 
      params[:password]
    ).authenticate

    if result == :success
      admin = Admin.find(params[:id])
      # CSRF対策
      reset_session
      # セッションを保存
      session[:admin_id] = admin.id
      # 最終アクセス時間
      session[:last_access_at] = Time.current
      render json: { message: "ログイン成功" }
    else
      render json: { error: "ログイン失敗" }, status: :unauthorized
    end
  end
end
