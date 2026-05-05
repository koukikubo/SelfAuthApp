class Api::V1::StaffSessionsController < ApplicationController
  def create
    staff = Auth::Staff::LoginService.call(
      id: params[:id], 
      password: params[:password]
    )
    raise BusinessError, "ログイン失敗" unless staff

    # CSRF対策
    reset_session
    # セッションIDを保存
    session[:staff_id] = staff.id
    # 最終ログイン時間
    session[:last_access_at] = Time.current
    render json: { message: "ログイン成功" }, status: :ok
  end
end
