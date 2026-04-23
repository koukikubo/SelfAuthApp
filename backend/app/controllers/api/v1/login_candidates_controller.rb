class Api::V1::LoginCandidatesController < ApplicationController
  def index
    # Admin取得（削除除外）
    admins = Admin.where(deleted: false).select(:id, :name)
    # Staff取得（削除除外）
    staffs = Staff.where(deleted: false).select(:id, :name)
    # type付与
    admin_data = admins.map do |a|
      {
        id: a.id,
        name: a.name,
        type: "admin"
      }
    end

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