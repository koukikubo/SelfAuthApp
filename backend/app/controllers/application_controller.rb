class ApplicationController < ActionController::Base
  include Authentication
  # 全てのコントローラーでセッションを使用できるようにする
  include ActionController::Cookies

  protect_from_forgery with: :exception

  private
  
  def current_user
    if session[:admin_id]
      Admin.find_by(id: session[:admin_id])
    elsif session[:staff_id]
      Staff.find_by(id: session[:staff_id])
    end
  end

end
