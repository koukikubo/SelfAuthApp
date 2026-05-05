require 'rails_helper'

RSpec.describe Auth::Staffs::AccountUnlockService, type: :service do
  let(:staff) do
    Staff.create!(
      name: "unlock_target",
      password: "password",
      password_confirmation: "password",
      effective_from: Date.current,
      role: :viewer,
      account_locked: true,
      failed_attempts: 3
    )
  end

  describe ".call" do
    it "管理者は担当者のロックを解除できる" do
      admin = Admin.create!(
        name: "unlock_admin",
        password: "password",
        password_confirmation: "password",
        effective_from: Date.current
      )

      described_class.call(staff: staff, operator: admin)

      staff.reload
      expect(staff.account_locked).to be false
      expect(staff.failed_attempts).to eq 0
    end

    it "owner権限の担当者は担当者のロックを解除できる" do
      owner = Staff.create!(
        name: "unlock_owner",
        password: "password",
        password_confirmation: "password",
        effective_from: Date.current,
        role: :owner
      )

      described_class.call(staff: staff, operator: owner)

      staff.reload
      expect(staff.account_locked).to be false
      expect(staff.failed_attempts).to eq 0
    end

    it "owner以外の担当者は解除できない" do
      operator = Staff.create!(
        name: "unlock_operator",
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
