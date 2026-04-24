module Auth
  module Admin
    class AdminAuthenticator < BaseAuthenticator
      def initialize(id, password)
        @id = id
        @password = password
      end

      def authenticate
        # 管理者を認証する
        admin = ::Admin.find_by(id: @id)
        # 管理者が存在しない場合はnilを返す
        authenticate_user(admin, @password)
      end
    end
  end
end