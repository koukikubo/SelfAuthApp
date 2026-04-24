class Api::V1::StaffSessionsController < ApplicationController
  def create
    id = params.require(:id)
    password = params.require(:password)
    staff = Auth::Staff::StaffAuthenticator.new(id, password).authenticate
    if staff
      reset_session
      session[:staff_id] = staff.id
      render json: { message: "ログイン成功" }, status: :ok
    else
      render json: { error: "ログイン失敗" }, status: :unauthorized
    end
  end

end
