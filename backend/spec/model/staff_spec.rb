require 'rails_helper'

RSpec.describe Staff, type: :model do
  let(:staff) do
    Staff.new(
      name: "test",
      password: "password",
      password_confirmation: "password",
      effective_from: Date.current,
      role: :viewer
    )
  end

  describe "パスワード" do
    it "認証できる" do
      staff.save!
      expect(staff.authenticate("password")).to be_truthy
    end

    it "認証失敗する" do
      staff.save!
      expect(staff.authenticate("wrong")).to be_falsey
    end
  end
  describe "role" do
    it "viewerとして保存される" do
      staff.save!
      expect(staff.viewer?).to be true
    end

    it "operatorに変更できる" do
      staff.role = :operator
      staff.save!
      expect(staff.operator?).to be true
    end
  end

  describe "#active_for_login?" do
    it "有効な場合true" do
      staff.save!
      expect(staff.active_for_login?).to be true
    end

    it "削除されていたらfalse" do
      staff.deleted = true
      staff.save!
      expect(staff.active_for_login?).to be false
    end

    it "ロックされていたらfalse" do
      staff.account_locked = true
      staff.save!
      expect(staff.active_for_login?).to be false
    end
  end

  describe "ロック機構" do
    it "失敗回数が増える" do
      staff.save!
      expect {
        staff.register_failed_attempt!
      }.to change { staff.failed_attempts }.by(1)
    end
  end
end