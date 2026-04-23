class Api::V1::AdminSessionsController < ApplicationController
  def create
    admin = Auth::Admin::AdminAuthenticator.new(params[:name], params[:password]).authenticate

    if admin
      reset_session
      session[:admin_id] = admin.id
      render json: { message: "ログイン成功" }
    else
      render json: { error: "ログイン失敗" }, status: :unauthorized
    end
  end
end


