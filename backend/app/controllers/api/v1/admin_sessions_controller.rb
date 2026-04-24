class Api::V1::AdminSessionsController < ApplicationController
  skip_forgery_protection only: :create

  def create
    admin = Auth::Admin::AdminAuthenticator.new(params[:id], params[:password]).authenticate

    if admin
      reset_session
      session[:admin_id] = admin.id
      render json: { message: "ログイン成功" }
    else
      render json: { error: "ログイン失敗" }, status: :unauthorized
    end
  end
end


