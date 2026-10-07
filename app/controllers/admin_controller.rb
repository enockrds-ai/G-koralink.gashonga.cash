class AdminController < ApplicationController
  before_action :require_admin
  def index
    @pending_savings=Saving.where(status:"pending").order(created_at: :desc)
    @pending_loans=Loan.where(status:"pending").order(created_at: :desc)
    @pending_members=Member.where(status:"pending").order(created_at: :desc)
    @pending_repayments=Transaction.where(status:"pending",kind:"loan_repayment").order(created_at: :desc)
  end
  def approve_member; m=Member.find(params[:id]); m.update!(status:"active"); notify(m.user_id,"BYEMEJWE","Konti yawe yemejwe."); redirect_to admin_path; end
  def reject_member; m=Member.find(params[:id]); m.update!(status:"inactive"); notify(m.user_id,"BYANZE","Konti yawe yanze."); redirect_to admin_path; end
  def approve_saving; s=Saving.find(params[:id]); s.update!(status:"approved"); notify(s.member.user_id,"BYEMEJWE","Ubwizigame bwa RWF #{s.amount} bwemejwe."); redirect_to admin_path; end
  def reject_saving; s=Saving.find(params[:id]); s.update!(status:"rejected"); notify(s.member.user_id,"BYANZE","Ubwizigame bwa RWF #{s.amount} bwanze."); redirect_to admin_path; end
  def approve_loan
    l=Loan.find(params[:id]); available=communal_available; max=(available*0.8).floor
    if l.amount.to_i<=max && !Loan.where(member_id:l.member_id,status:"active").where.not(id:l.id).exists?
      l.update!(status:"active"); notify(l.member.user_id,"BYEMEJWE","Inguzanyo ya RWF #{l.amount} yemejwe.")
    else
      l.update!(status:"rejected"); notify(l.member.user_id,"BYANZE","Inguzanyo ntiyemejwe.")
    end
    redirect_to admin_path
  end
  def reject_loan; l=Loan.find(params[:id]); l.update!(status:"rejected"); notify(l.member.user_id,"BYANZE","Inguzanyo ya RWF #{l.amount} yanze."); redirect_to admin_path; end
  def approve_repayment
    tx=Transaction.find(params[:id]); lid=tx.note.to_s.delete_prefix("REPAY-").to_i; l=Loan.find_by(id:lid,member_id:tx.member_id,status:"active")
    if l && tx.amount.to_i<=l.balance.to_i
      b=l.balance.to_i-tx.amount.to_i; l.update!(amount_paid:l.amount_paid.to_i+tx.amount.to_i,balance:b,status:(b<=0 ? "paid" : "active")); tx.update!(status:"approved"); notify(tx.member.user_id,"BYEMEJWE","Kwishyura RWF #{tx.amount} kwemejwe.")
    else
      tx.update!(status:"rejected"); notify(tx.member.user_id,"BYANZE","Kwishyura ntikwemejwe.")
    end
    redirect_to admin_path
  end
  def reject_repayment; tx=Transaction.find(params[:id]); tx.update!(status:"rejected"); notify(tx.member.user_id,"BYANZE","Kwishyura RWF #{tx.amount} kwanzwe."); redirect_to admin_path; end
  private
  def require_admin; redirect_to dashboard_path,alert:"Admin gusa." unless current_user&.role.to_s=="admin"; end
  def notify(uid,title,body); Notification.create!(user_id:uid,title:title,body:body,kind:"approval",is_read:false); end
  def communal_available
    s=Saving.where(status:"approved").sum(:amount).to_i
    i=Transaction.where(kind:"interest",status:"approved").sum(:amount).to_i
    l=Loan.where(status:"active").sum(:balance).to_i
    [s+i-l,0].max
  end
end
