require 'rails_helper'

RSpec.describe "Sessions API", type: :request do
  # ===============================
  # テストデータ
  # ===============================
  let!(:admin) do
    Admin.create!(
      name: "管理者",
      password: "password",
      password_confirmation: "password",
      effective_from: Date.current
    )
  end

  let!(:staff) do
    Staff.create!(
      name: "スタッフ",
      password: "password",
      password_confirmation: "password",
      effective_from: Date.current
    )
  end

  # ===============================
  # CSRFトークン取得
  # ===============================
  def csrf_token
    get "/api/v1/csrf", as: :json
    JSON.parse(response.body)["csrf_token"]
  end

  # ===============================
  # 未ログイン
  # ===============================
  it "未ログイン時は /session が401になる" do
    get "/api/v1/session"

    expect(response).to have_http_status(:unauthorized)
  end

  # ===============================
  # Adminログイン
  # ===============================
  it "adminログイン成功 → session取得できる" do
    post "/api/v1/admin/login",
      params: { name: "管理者", password: "password" },
      headers: { "X-CSRF-Token" => csrf_token }

    get "/api/v1/session"

    json = JSON.parse(response.body)

    expect(response).to have_http_status(:ok)
    expect(json["type"]).to eq("admin")
    expect(json["name"]).to eq("管理者")
  end

  # ===============================
  # Staffログイン
  # ===============================
  it "staffログイン成功 → session取得できる" do
    post "/api/v1/staff/login",
      params: { name: "スタッフ", password: "password" },
      headers: { "X-CSRF-Token" => csrf_token }

    get "/api/v1/session"

    json = JSON.parse(response.body)

    expect(response).to have_http_status(:ok)
    expect(json["type"]).to eq("staff")
    expect(json["name"]).to eq("スタッフ")
  end

  # ===============================
  # ログイン失敗
  # ===============================
  it "ログイン失敗時は401" do
    post "/api/v1/admin/login",
      params: { name: "管理者", password: "wrong" },
      headers: { "X-CSRF-Token" => csrf_token }

    expect(response).to have_http_status(:unauthorized)
  end

  # ===============================
  # ログアウト
  # ===============================
  it "ログアウト成功 → session消える" do
    # ログイン
    post "/api/v1/admin/login",
      params: { name: "管理者", password: "password" },
      headers: { "X-CSRF-Token" => csrf_token }

    # ログアウト
    delete "/api/v1/logout",
      headers: { "X-CSRF-Token" => csrf_token }

    # 確認
    get "/api/v1/session"

    expect(response).to have_http_status(:unauthorized)
  end
end