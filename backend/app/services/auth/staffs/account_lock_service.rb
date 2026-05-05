module Auth
  module Staffs
    class AccountLockService < BaseService
      def initialize(staff:, operator:)
        @staff = staff
        @operator = operator
      end

      def call
        # 可能な人かをチェック
        authorize!
        # 例外が出たらロールバック
        with_transaction do
          raise BusinessError, "すでにアカウントロック済みです" if @staff.account_locked?

          @staff.update!(
            account_locked: true
          )
          # 監査ログを残す
          log_info("staff_id=#{@staff.id} locked by operator_id=#{@operator.id}")
        end

        @staff
      end

      private
      # 管理者、owner権限であればOK
      def authorize!
        return if @operator.is_a?(::Admin)
        return if @operator.is_a?(::Staff) && @operator.owner?

        raise AuthorizationError, "権限がありません"
      end
    end
  end
end
