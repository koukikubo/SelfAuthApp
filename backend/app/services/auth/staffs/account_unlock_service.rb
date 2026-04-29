module Auth
  module Staff
    # 担当者マスタのアカウントロック解除のメソッド
    class AccountUnlockService < BaseService
      def initialize(staff, operator)
        @staff = staff
        @operator = operator
      end

      def call
        raise "権限なし" unless allowed?

        @staff.update!(
          account_locked: false,
          failed_attempts: 0
        )

        log_action

        @staff
      end

      private

      def allowed?
        @operator.is_a?(Admin) || @operator&.owner?
      end

      def log_action
        Rails.logger.info("staff unlocked by #{@operator.id}")
      end
    end
  end
end