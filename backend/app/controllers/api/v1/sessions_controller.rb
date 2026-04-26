class Api::V1::SessionsController < ApplicationController
  def show
    # application_controllerで判断するため、current_userを使用。
    user = current_user
    # userが無ければ、401
    return render json: { error: "未ログイン" }, status: :unauthorized unless user
    # 正常レスポンス
    render json: {
      id: user.id,
      name: user.name,
      type: user.is_a?(Admin) ? "admin" : "staff",
      role: user.try(:role)
    }
  end

  def destroy
    reset_session
    head :no_content
  end
end
