class ApplicationController < ActionController::Base
  # 全てのコントローラーでセッションを使用できるようにする
  include ActionController::Cookies

  protect_from_forgery with: :exception
  
  private
  
  def current_user
    # セッションにユーザーIDとユーザータイプが保存されているか確認
    return nil unless session[:user_id] && session[:user_type]
    # ユーザーの種類に応じて、AdminまたはStaffを検索して返す
    if session[:user_type] == "admin"
      Admin.find_by(id: session[:user_id])
    else
      Staff.find_by(id: session[:user_id])
    end
  end

end
