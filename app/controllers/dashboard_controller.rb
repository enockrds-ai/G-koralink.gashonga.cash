class DashboardController < ApplicationController
  def index
    @member = Member.find_by(user_id: current_user.id)
    @savings = @member ? Saving.where(member_id: @member.id).order(created_at: :desc) : Saving.none
    @group = @member&.group || Group.first
    @total_savings = Saving.where(status: "approved").sum(:amount)
  end
end
