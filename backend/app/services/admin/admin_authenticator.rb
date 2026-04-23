class Auth::AdminAuthenticator < BaseAuthenticator
  def initialize(name, password)
    @name = name
    @password = password
  end

  def authenticate
    # 管理者を認証する
    admin = Admin.find_by(name: @name)
    # 管理者が存在しない場合はnilを返す
    authenticate_user(admin, @password)
  end
end