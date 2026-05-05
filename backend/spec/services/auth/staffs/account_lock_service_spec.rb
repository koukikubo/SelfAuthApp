require 'rails_helper'

RSpec.describe Auth::Staffs::AccountLockService, type: :service do
  let(:staff) do
    Staff.create!(
      name: "lock_target",
      password: "password",
      password_confirmation: "password",
      effective_from: Date.current,
      role: :viewer
    )
  end

  describe ".call" do
    it "管理者は担当者をロックできる" do
      admin = Admin.create!(
        name: "lock_admin",
        password: "password",
        password_confirmation: "password",
        effective_from: Date.current
      )

      described_class.call(staff: staff, operator: admin)

      expect(staff.reload.account_locked).to be true
    end

    it "owner権限の担当者は担当者をロックできる" do
      owner = Staff.create!(
        name: "lock_owner",
        password: "password",
        password_confirmation: "password",
        effective_from: Date.current,
        role: :owner
      )

      described_class.call(staff: staff, operator: owner)

      expect(staff.reload.account_locked).to be true
    end

    it "owner以外の担当者はロックできない" do
      operator = Staff.create!(
        name: "lock_operator",
        password: "password",
        password_confirmation: "password",
        effective_from: Date.current,
        role: :operator
      )

      expect {
        described_class.call(staff: staff, operator: operator)
      }.to raise_error(AuthorizationError, "権限がありません")
    end
  end
end
