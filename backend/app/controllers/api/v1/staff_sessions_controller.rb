class Api::V1::StaffSessionsController < ApplicationController
  skip_forgery_protection only: :create

  def create
    staff = Auth::Staff::StaffAuthenticator.new(params[:id], params[:password]).authenticate

    if staff
      reset_session
      session[:staff_id] = staff.id
      render json: { message: "ログイン成功" }
    else
      render json: { error: "ログイン失敗" }, status: :unauthorized
    end
  end

end
