module Auth
  module Staff
    class StaffAuthenticator < BaseAuthenticator
      def initialize(id, password)
        @id = id
        @password = password
      end

    # スタッフを認証する
      def authenticate
        staff = ::Staff.find_by(id: @id)
        authenticate_user(staff, @password)
      end
      
    end
  end
end 