class Api::V1::StaffsController < ApplicationController
  before_action :require_owner_or_admin!
  before_action :set_staff, only: [:show, :update, :destroy, :account_lock, :account_unlock, :retire, :restore]

  def index
    staffs = Staff.where(deleted: false)
    render json: staffs.map { |s| staff_json(s) }
  end

  def create
    staff = Staff.create!(staff_params)
    render json: staff, status: :created
  end

  def show
    render json: staff_json(@staff)
  end

  def update
    @staff.update!(staff_params)
    render json: staff_json(@staff)
  end

  def destroy
    @staff.destroy!
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

  def retire
    @staff.update!(deleted: true)
    render json: staff_json(@staff)
  end

  def retired
    staffs = Staff.where(deleted: true)
    render json: staffs.map { |s|
    staff_json(s)
  }
  end

  def restore
    @staff.update!(deleted: false)
    render json: staff_json(@staff)
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

  def staff_json(staff)
    {
      id: staff.id,
      name: staff.name,
      role: staff.role,
      account_locked: staff.account_locked,
      effective_from: staff.effective_from,
      effective_to: staff.effective_to
    }
  end

  def set_staff
    @staff = Staff.find(params[:id])
  end

end
