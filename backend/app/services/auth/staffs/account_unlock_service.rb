module Auth
  module Staffs
    # 担当者マスタのアカウントロック解除のメソッド
    class AccountUnlockService < BaseService
      def initialize(staff:, operator:)
        @staff = staff
        @operator = operator
      end

      def call
        raise AuthorizationError, "権限がありません" unless allowed?
        
        @staff.update!(
          account_locked: false,
          failed_attempts: 0
        )

        log_action

        @staff
      end

      private

      def allowed?
        @operator.is_a?(::Admin) || (@operator.is_a?(::Staff) && @operator.owner?)
      end

      def log_action
        Rails.logger.info("staff unlocked by #{@operator.id}")
      end
    end
  end
end
