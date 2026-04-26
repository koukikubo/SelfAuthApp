class Api::V1::StaffSessionsController < ApplicationController
  def create
    staff = Auth::Staff::StaffAuthenticator.new(params[:id], params[:password]).authenticate

    if staff
      # CSRF対策
      reset_session
      # セッションIDを保存
      session[:staff_id] = staff.id
      # 最終ログイン時間
      session[:last_access_at] = Time.current
      render json: { message: "ログイン成功" }
    else
      render json: { error: "ログイン失敗" }, status: :unauthorized
    end
  end

end
