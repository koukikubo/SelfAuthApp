class Api::V1::AdminSessionsController < ApplicationController
  def create
    id = params.require(:id)
    password = params.require(:password)
    admin = Auth::Admin::AdminAuthenticator
      .new(id, password)
      .authenticate
    if admin
      reset_session
      session[:admin_id] = admin.id
      render json: { message: "ログイン成功" }, status: :ok
    else
      render json: { error: "ログイン失敗" }, status: :unauthorized
    end
  end
end


