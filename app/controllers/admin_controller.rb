class AdminController < ApplicationController
  before_action :require_admin
  def index
    @pending_savings=Saving.where(status:"pending").order(created_at: :desc)
    @pending_loans=Loan.where(status:"pending").order(created_at: :desc)
    @members=Member.order(created_at: :desc)
  end
  def approve_saving
    saving=Saving.find(params[:id]); saving.update!(status:"approved")
    redirect_to admin_path,notice:"Ubwizigame bwemejwe."
  end
  def approve_loan
    loan=Loan.find(params[:id])
    available=[Saving.where(status:"approved").sum(:amount)-Loan.where(status:"active").sum(:balance),0].max
    if loan.amount <= (available*0.8).floor
      loan.update!(status:"active"); msg="Inguzanyo yemejwe."
    else
      loan.update!(status:"rejected"); msg="Inguzanyo irenze amafaranga yemerewe."
    end
    redirect_to admin_path,notice:msg
  end
  private
  def require_admin
    redirect_to dashboard_path,alert:"Admin gusa." unless current_user&.role.to_s=="admin"
  end
end