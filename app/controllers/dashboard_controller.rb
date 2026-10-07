class DashboardController < ApplicationController
  def index
    @member = Member.find_by(user_id: current_user.id)
    @group = @member&.group || Group.first
    @members = Member.order(created_at: :asc)
    @savings = @member ? Saving.where(member_id: @member.id).order(created_at: :desc) : Saving.none
    @approved_savings = Saving.where(status: "approved").sum(:amount).to_i
    @approved_interest = Transaction.where(kind: "interest", status: "approved").sum(:amount).to_i
    @active_loans = Loan.where(status: "active").sum(:balance).to_i
    @communal_available = [@approved_savings + @approved_interest - @active_loans, 0].max
    @max_loan = (@communal_available * 0.8).floor
    @my_loan = @member && Loan.where(member_id: @member.id, status: "active").order(created_at: :desc).first
    @notifications = Notification.where(user_id: current_user.id).order(created_at: :desc).limit(10)
  end
end
