class Auth::StaffAuthenticator < BaseAuthenticator
  # スタッフの認証を行うクラス
  def initialize(name, password)
    @name = name
    @password = password
  end

  # スタッフを認証する
  def authenticate
    staff = Staff.find_by(name: @name)
    return nil unless staff
    authenticate_user(staff, @password)

    return nil unless staff.active_for_login?
    # パスワードが正しいか確認
    if staff.authenticate(@password)
      staff.reset_failed_attempts!
      staff
    else
      # パスワードが間違っている場合は失敗回数を記録
      staff.register_failed_attempt!
      nil
    end
  end
end