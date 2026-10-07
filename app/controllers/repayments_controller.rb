class RepaymentsController < ApplicationController
  def create
    member=Member.find_by(user_id:current_user.id)
    loan=member && Loan.find_by(id:params[:loan_id],member_id:member.id,status:"active")
    amount=params[:amount].to_i
    if loan.nil? || amount<=0 || amount>loan.balance.to_i
      redirect_to dashboard_path,alert:"Amafaranga yo kwishyura si yo."; return
    end
    new_balance=loan.balance.to_i-amount
    loan.update!(amount_paid:loan.amount_paid.to_i+amount,balance:new_balance,status:(new_balance<=0 ? "paid" : "active"))
    redirect_to dashboard_path,notice:"Ubwishyu bwoherejwe."
  end
end
