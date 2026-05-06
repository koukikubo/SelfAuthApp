require 'rails_helper'

RSpec.describe Auth::BaseAuthenticator do
  subject(:authenticator) { described_class.new }

  describe "#authenticate_user" do
    it "ユーザーが存在しない場合はnot_foundを返す" do
      expect(authenticator.authenticate_user(nil, "password")).to eq(:not_found)
    end

    it "パスワードが違う場合はinvalid_passwordを返す" do
      user = instance_double("User", authenticate: false)

      expect(authenticator.authenticate_user(user, "wrong")).to eq(:invalid_password)
    end

    it "ログイン不可状態の場合はinactiveを返す" do
      user = instance_double("User", authenticate: true, active_for_login?: false)

      expect(authenticator.authenticate_user(user, "password")).to eq(:inactive)
    end

    it "認証成功の場合はsuccessを返す" do
      user = instance_double("User", authenticate: true, active_for_login?: true)

      expect(authenticator.authenticate_user(user, "password")).to eq(:success)
    end
  end
end
