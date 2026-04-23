class Api::V1::SessionsController < ApplicationController
  def destroy
    reset_session
    render json: { message: "ログアウトしました" }, status: :ok
  end
end