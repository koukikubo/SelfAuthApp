class Api::V1::SessionsController < ApplicationController
  
  def create
    # リクエストからユーザー名、パスワード、ロールを取得
    name = params[:name]
    password = params[:password]
    role = params[:role] # "admin" or "staff"
    # ロールに応じて認証クラスを選択して認証を行う
    user =
      if role == "admin"
        Auth::AdminAuthenticator.new(name, password).authenticate
      else
        Auth::StaffAuthenticator.new(name, password).authenticate
      end
    # 認証に成功した場合はセッションにユーザーIDとロールを保存し、成功メッセージを返す
    if user
      session[:user_id] = user.id
      session[:user_type] = role

      render json: { message: "ログイン成功" }, status: :ok
    else
      render json: { error: "ログイン失敗" }, status: :unauthorized
    end
  end

  def destroy
    reset_session
    render json: { message: "ログアウトしました" }, status: :ok
  end

end
