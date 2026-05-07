require 'rails_helper'

RSpec.describe Auth::Staff::LoginService, type: :service do
  let!(:staff) do
    Staff.create!(
      name: "login_staff",
      password: "password",
      password_confirmation: "password",
      effective_from: Date.current,
      role: :operator
    )
  end

  describe ".call" do
    it "ログイン成功時は担当者を返し、失敗回数をリセットする" do
      staff.update!(failed_attempts: 2)

      result = described_class.call(id: staff.id, password: "password")

      expect(result).to eq(staff)
      expect(staff.reload.failed_attempts).to eq(0)
    end

    it "パスワードが違う場合は失敗回数を増やしてBusinessErrorを発生させる" do
      expect {
        described_class.call(id: staff.id, password: "wrong")
      }.to raise_error(BusinessError, "正しいパスワードを入力してください。")

      expect(staff.reload.failed_attempts).to eq(1)
      expect(staff.account_locked).to be false
    end

    it "失敗回数が上限に達した場合はアカウントをロックする" do
      staff.update!(failed_attempts: described_class::MAX_FAILED_ATTEMPTS - 1)

      expect {
        described_class.call(id: staff.id, password: "wrong")
      }.to raise_error(BusinessError, "正しいパスワードを入力してください。")

      staff.reload
      expect(staff.failed_attempts).to eq(described_class::MAX_FAILED_ATTEMPTS)
      expect(staff.account_locked).to be true
    end

    it "ログイン不可状態の場合はBusinessErrorを発生させる" do
      staff.update!(account_locked: true)

      expect {
        described_class.call(id: staff.id, password: "password")
      }.to raise_error(BusinessError, "ログイン不可状態です")
    end

    it "存在しないIDの場合はBusinessErrorを発生させる" do
      expect {
        described_class.call(id: Staff.maximum(:id).to_i + 1, password: "password")
      }.to raise_error(BusinessError, "ユーザーが存在しません")
    end
  end
end
