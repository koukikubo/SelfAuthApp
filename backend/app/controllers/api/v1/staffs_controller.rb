class Api::V1::StaffsController < ApplicationController
  before_action :require_owner_or_admin!
  before_action :set_staff, only: [:account_lock, :account_unlock]

  def index
    staffs = Staff.where(deleted: false)
    render json: staffs.map { |s| {
      id: s.id,
      name: s.name,
      role: s.role,
      account_locked: s.account_locked,
      effective_from: s.effective_from,
      effective_to: s.effective_to
    } }
  end

  def create
    staff = Staff.create!(staff_params)
    render json: staff, status: :created
  end

  def show
    staff = Staff.find(params[:id])
    render json: {
      id: staff.id,
      name: staff.name,
      role: staff.role,
      account_locked: staff.account_locked,
      effective_from: staff.effective_from,
      effective_to: staff.effective_to
    }
  end

  def update
    staff = Staff.find(params[:id])
    staff.update!(staff_params)
    render json: {
      id: staff.id,
      name: staff.name,
      role: staff.role,
      account_locked: staff.account_locked,
      effective_from: staff.effective_from,
      effective_to: staff.effective_to
    }
  end

  def destroy
    staff = Staff.find(params[:id])
    staff.update!(deleted: true)
    head :no_content
  end

  def account_lock
    staff = Auth::Staffs::AccountLockService.call(
      staff: @staff,
      operator: current_user
    )

    render json: { message: "アカウントをロックしました。解除は管理者へ申請してください。", staff: staff }
  end

  def account_unlock
    staff = Auth::Staffs::AccountUnlockService.call(
      staff: @staff,
      operator: current_user
    )

    render json: { message: "アカウントのロックを解除しました" }
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

  def set_staff
    @staff = Staff.find(params[:id])
  end

end
