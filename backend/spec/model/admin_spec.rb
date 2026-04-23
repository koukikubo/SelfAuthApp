require 'rails_helper'

RSpec.describe Admin, type: :model do
  it "nameがないと無効" do
    admin = Admin.new(password: "pass", effective_from: Date.today)
    expect(admin).not_to be_valid
  end
  it "パスワード認証ができる" do
    admin = Admin.create!(
      name: "test",
      password: "pass",
      password_confirmation: "pass",
      effective_from: Date.today
    )

    expect(admin.authenticate("pass")).to be_truthy
  end
end