class Api::V1::StaffsController < ApplicationController
  before_action :require_owner_or_admin!

  def index
    staffs = Staff.where(deleted: false)
    render json: staffs
  end

  def create
    staff = Staff.create!(staff_params)
    render json: staff, status: :created
  end

  def update
    staff = Staff.find(params[:id])
    staff.update!(staff_params)
    render json: staff
  end

  def destroy
    staff = Staff.find(params[:id])
    staff.update!(deleted: true)
    head :no_content
  end

  private

  def staff_params
    params.require(:staff).permit(
      :name,
      :password,
      :password_confirmation,
      :role,
      :effective_from,
      :effective_to
    )
  end
end