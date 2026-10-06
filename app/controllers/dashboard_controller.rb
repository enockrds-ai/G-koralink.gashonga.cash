class DashboardController < ApplicationController
  def index
    @group = Group.first
    @members = Member.where(group_id: @group&.id).order(:display_name)
    @approved_savings = Saving.where(status: "approved").sum(:amount)
    @active_loans = Loan.where(status: "active").sum(:balance)
  end
end
