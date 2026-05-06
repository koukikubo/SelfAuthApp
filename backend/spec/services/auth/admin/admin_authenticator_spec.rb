require 'rails_helper'

RSpec.describe Auth::Admin::AdminAuthenticator, type: :service do
  let!(:admin) do
    Admin.create!(
      name: "auth_admin",
      password: "password",
      password_confirmation: "password",
      effective_from: Date.current
    )
  end

  describe "#authenticate" do
    it "正しいパスワードならsuccessを返す" do
      result = described_class.new(admin.id, "password").authenticate

      expect(result).to eq(:success)
    end

    it "存在しないIDならnot_foundを返す" do
      result = described_class.new(Admin.maximum(:id).to_i + 1, "password").authenticate

      expect(result).to eq(:not_found)
    end

    it "パスワードが違う場合はinvalid_passwordを返す" do
      result = described_class.new(admin.id, "wrong").authenticate

      expect(result).to eq(:invalid_password)
    end

    it "ログイン不可状態ならinactiveを返す" do
      admin.update!(account_locked: true)

      result = described_class.new(admin.id, "password").authenticate

      expect(result).to eq(:inactive)
    end
  end
end
