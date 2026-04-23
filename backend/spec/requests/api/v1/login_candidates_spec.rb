require 'securerandom'
require 'rails_helper'

RSpec.describe "LoginCandidates API", type: :request do
  let!(:admin) do
    Admin.create!(
      name: "管理者",
      password: "password",
      password_confirmation: "password",
      effective_from: Date.current,
      deleted: false
    )
  end

  let!(:staff) do
    Staff.create!(
      name: "大阪太郎_#{SecureRandom.hex(4)}",
      password: "password",
      password_confirmation: "password",
      effective_from: Date.current,
      role: :operator, 
      deleted: false
    )
  end

  let!(:deleted_staff) do
    Staff.create!(
      name: "大阪太郎_#{SecureRandom.hex(4)}",
      password: "password",
      password_confirmation: "password",
      effective_from: Date.current,
      role: :operator,
      deleted: true
    )
  end

  it "AdminとStaffが含まれる" do
    get "/api/v1/login_candidates", as: :json

    json = JSON.parse(response.body)

    expect(json.map { |u| u["name"] }).to include(admin.name, staff.name)  
  end
  it "typeが正しい" do
    get "/api/v1/login_candidates", as: :json

    json = JSON.parse(response.body)

    admin_json = json.find { |u| u["name"] == admin.name }
    staff_json = json.find { |u| u["name"] == staff.name }  
    expect(admin_json["type"]).to eq("admin")
    expect(staff_json["type"]).to eq("staff")
  end

  it "deletedは除外される" do
    get "/api/v1/login_candidates", as: :json

    json = JSON.parse(response.body)

    names = json.map { |u| u["name"] }

    expect(names).not_to include(deleted_staff.name)
  end
end