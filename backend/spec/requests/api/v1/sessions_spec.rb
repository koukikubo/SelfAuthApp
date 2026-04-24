require 'rails_helper'

RSpec.describe "Api::V1::Sessions", type: :request do
  # ===============================
  # テスト用データ準備
  # ===============================
  let!(:admin) do
    Admin.create!(
      name: "管理者",
      password: "password",
      password_confirmation: "password",
      effective_from: Date.current
    )
  end

  # ===============================
  # CSRFトークン取得ヘルパー
  # ===============================
  def csrf_token
    get "/api/v1/csrf"
    JSON.parse(response.body)["csrf_token"]
  end

  # ===============================
  # ログイン成功
  # ===============================
  describe "POST /api/v1/admin/login" do
    it "ログイン成功する" do
      post "/api/v1/admin/login",
        params: {
          id: admin.id,
          password: "password"
        },
        headers: {
          "X-CSRF-Token" => csrf_token
        }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("ログイン成功")
    end

    it "ログイン失敗する（パスワード違い）" do
      post "/api/v1/admin/login",
        params: {
          id: admin.id,
          password: "wrong"
        },
        headers: {
          "X-CSRF-Token" => csrf_token
        }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  # ===============================
  # セッション保持確認
  # ===============================
  describe "session保持" do
    it "ログイン後にsessionが維持される" do
      # ログイン
      post "/api/v1/admin/login",
        params: {
          id: admin.id,
          password: "password"
        },
        headers: {
          "X-CSRF-Token" => csrf_token
        }

      # session確認
      get "/api/v1/session"

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["type"]).to eq("admin")
      expect(json["id"]).to eq(admin.id)
    end
  end

  # ===============================
  # ログアウト
  # ===============================
  describe "DELETE /api/v1/logout" do
    it "ログアウト成功する" do
      # ① ログイン
      post "/api/v1/admin/login",
        params: {
          id: admin.id,
          password: "password"
        },
        headers: {
          "X-CSRF-Token" => csrf_token
        }

      # ⚠️ reset_sessionでCSRF変わるので再取得
      new_token = csrf_token

      # ② ログアウト
      delete "/api/v1/logout",
        headers: {
          "X-CSRF-Token" => new_token
        }

      expect(response).to have_http_status(:ok)
    end
  end

  # ===============================
  # show（ログイン状態取得）
  # ===============================
  describe "GET /api/v1/session" do
    it "ログイン中ならuserが返る" do
      post "/api/v1/admin/login",
        params: {
          id: admin.id,
          password: "password"
        },
        headers: {
          "X-CSRF-Token" => csrf_token
        }

      get "/api/v1/session"

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["type"]).to eq("admin")
    end

    it "未ログインなら401" do
      get "/api/v1/session"

      expect(response).to have_http_status(:unauthorized)
    end
  end
end