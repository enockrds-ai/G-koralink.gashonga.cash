class LoansController < ApplicationController
  def create
    member=Member.find_by(user_id:current_user.id); amount=params[:amount].to_i
    available=[Saving.where(status:"approved").sum(:amount).to_i+Transaction.where(kind:"interest",status:"approved").sum(:amount).to_i-Loan.where(status:"active").sum(:balance).to_i,0].max
    max_loan=(available*0.8).floor
    if member.nil? || amount<=0
      redirect_to dashboard_path,alert:"Shyiramo amafaranga y'inguzanyo."
    elsif Loan.exists?(member_id:member.id,status:"active")
      redirect_to dashboard_path,alert:"Ufite inguzanyo igikora."
    elsif amount>max_loan
      redirect_to dashboard_path,alert:"Inguzanyo irenze 80% y'amafaranga ahari rusange."
    else
      loan=Loan.create!(member_id:member.id,amount:amount,amount_paid:0,balance:amount,interest_rate:5,interest_amount:(amount*0.05).round,total_repayment:(amount*1.05).round,status:"pending")
      User.where(role:"admin").pluck(:id).each{|uid| Notification.create!(user_id:uid,title:"IBITEGEREJE KWEMEZWA",body:"Inguzanyo ya RWF #{amount} yasabwe (##{loan.id}).",kind:"loan_request",is_read:false)}
      redirect_to dashboard_path,notice:"Gusaba inguzanyo byoherejwe kuri Admin."
    end
  end
end
