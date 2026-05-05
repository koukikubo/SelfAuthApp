class Api::V1::LoginCandidatesController < ApplicationController
  # システムログイン画面ログイン前のコントローラー
  def index
    today = Date.current
    admins = Admin
      .where(deleted: false, account_locked: false)
      .where("effective_from <= ?", today)
      .where("effective_to IS NULL OR effective_to > ?", today)
      .select(:id, :name)

    staffs = Staff
      .where(deleted: false, account_locked: false)
      .where("effective_from <= ?", today)
      .where("effective_to IS NULL OR effective_to > ?", today)
      .select(:id, :name)

    # ログイン時にAPI分岐させるため、Typeを付与
    admin_data = admins.map do |a|
      {
        id: a.id,
        name: a.name,
        type: "admin"
      }
    end
        # 同上

    staff_data = staffs.map do |s|
      {
        id: s.id,
        name: s.name,
        type: "staff"
      }
    end
    # 結合して返す
    render json: admin_data + staff_data
  end
end
