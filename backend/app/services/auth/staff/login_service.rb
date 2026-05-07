module Auth
  module Staff
    class LoginService < BaseService
      MAX_FAILED_ATTEMPTS = 30

      def initialize(id:, password:)
        @id = id
        @password = password
      end

      def call
        Rails.logger.debug("LoginService start id=#{@id}")

        staff = ::Staff.find_by(id: @id)
        Rails.logger.debug("staff=#{staff.inspect}")

        result = Auth::Staff::StaffAuthenticator.new(@id, @password).authenticate
        Rails.logger.debug("result=#{result.inspect}")
        
        case result
        when :success
          handle_success(staff)
          return staff
        when :invalid_password
          handle_failure(staff)
        when :inactive
          raise BusinessError, "ログイン不可状態です"
        when :not_found
          raise BusinessError, "ユーザーが存在しません"
        end

        staff
      end

      private
      # 検証に成功したとき
      def handle_success(staff)
        staff.reset_failed_attempts!
        log_info("login success staff_id=#{staff.id}")
        
      end
      # 検証に失敗したとき
      def handle_failure(staff)
        staff.register_failed_attempt!

        if staff.failed_attempts >= MAX_FAILED_ATTEMPTS
          lock_account!(staff)
        end

        log_info("login failed staff_id=#{staff.id} attempts=#{staff.failed_attempts}")

        raise BusinessError, "正しいパスワードを入力してください。"
      end

      def lock_account!(staff)
        staff.update!(account_locked: true)
        log_info("staff_id=#{staff.id} locked by failed attempts")
      end
    end
  end
end
