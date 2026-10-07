class AdminController < ApplicationController
  before_action :require_admin
  def index
    @pending_savings=Saving.where(status:"pending").order(created_at: :desc)
    @pending_loans=Loan.where(status:"pending").order(created_at: :desc)
    @pending_members=Member.where(status:"pending").order(created_at: :desc)
  end
  def approve_member; member=Member.find(params[:id]); member.update!(status:"active"); notify(member.user_id,"BYEMEJWE","Konti yawe yemejwe."); redirect_to admin_path; end
  def reject_member; member=Member.find(params[:id]); member.update!(status:"inactive"); notify(member.user_id,"BYANZE","Konti yawe yanze."); redirect_to admin_path; end
  def approve_saving; saving=Saving.find(params[:id]); saving.update!(status:"approved"); notify(saving.member.user_id,"BYEMEJWE","Ubwizigame bwa RWF #{saving.amount} bwemejwe."); redirect_to admin_path; end
  def reject_saving; saving=Saving.find(params[:id]); saving.update!(status:"rejected"); notify(saving.member.user_id,"BYANZE","Ubwizigame bwa RWF #{saving.amount} bwanze."); redirect_to admin_path; end
  def approve_loan
    loan=Loan.find(params[:id]); available=[Saving.where(status:"approved").sum(:amount)-Loan.where(status:"active").sum(:balance),0].max
    if loan.amount <= (available*0.8).floor && !Loan.where(member_id:loan.member_id,status:"active").where.not(id:loan.id).exists?
      loan.update!(status:"active"); notify(loan.member.user_id,"BYEMEJWE","Inguzanyo ya RWF #{loan.amount} yemejwe.")
    else
      loan.update!(status:"rejected"); notify(loan.member.user_id,"BYANZE","Inguzanyo ntiyemejwe.")
    end
    redirect_to admin_path
  end
  def reject_loan; loan=Loan.find(params[:id]); loan.update!(status:"rejected"); notify(loan.member.user_id,"BYANZE","Inguzanyo ya RWF #{loan.amount} yanze."); redirect_to admin_path; end
  private
  def require_admin; redirect_to dashboard_path,alert:"Admin gusa." unless current_user&.role.to_s=="admin"; end
  def notify(user_id,title,body); Notification.create!(user_id:user_id,title:title,body:body,kind:"approval",is_read:false); end
end
