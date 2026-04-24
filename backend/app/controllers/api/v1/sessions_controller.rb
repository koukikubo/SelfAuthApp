class Api::V1::SessionsController < ApplicationController

  def show
    if session[:admin_id]
      admin = Admin.find_by(id: session[:admin_id])
      return render json: { type: "admin", id: admin.id } if admin
    end

    if session[:staff_id]
      staff = Staff.find_by(id: session[:staff_id])
      return render json: { type: "staff", id: staff.id } if staff
    end

    render json: { error: "未ログイン" }, status: :unauthorized
  end
  
  def destroy
    reset_session
    render json: { message: "ログアウトしました" }, status: :ok
  end
end