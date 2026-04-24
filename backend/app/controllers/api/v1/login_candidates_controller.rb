class Api::V1::LoginCandidatesController < ApplicationController
  def index
    # 有効な管理者とスタッフを取得  
    today = Date.current

    # 有効な管理者とスタッフを取得
    admins = Admin
      .where(deleted: false)
      .where(account_locked: false)
      .where("effective_from <= ?", today)
      .where("effective_to IS NULL OR effective_to >= ?", today)

    # 有効なスタッフを取得
    staffs = Staff
      .where(deleted: false)
      .where(account_locked: false)
      .where("effective_from <= ?", today)
      .where("effective_to IS NULL OR effective_to >= ?", today)
    # 管理者とスタッフを結合してJSONで返す
    admin_data = admins.map do |a|
      { id: a.id, name: a.name, type: "admin" }
    end
    # スタッフのデータを作成
    staff_data = staffs.map do |s|
      { id: s.id, name: s.name, type: "staff" }
    end
    # 管理者とスタッフのデータを結合してJSONで返す
    render json: admin_data + staff_data
  end
end