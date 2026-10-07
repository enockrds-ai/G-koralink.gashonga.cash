class RepaymentsController < ApplicationController
  def create
    member = Member.find_by(user_id: current_user.id)
    loan = member && Loan.find_by(id: params[:loan_id], member_id: member.id, status: "active")
    amount = params[:amount].to_i
    if loan.nil? || amount <= 0 || amount > loan.balance.to_i
      redirect_to dashboard_path, alert: "Amafaranga yo kwishyura si yo."
      return
    end
    tx = Transaction.create!(member_id: member.id, amount: amount, kind: "loan_repayment", status: "pending", note: "REPAY-#{loan.id}")
    User.where(role: "admin").pluck(:id).each do |uid|
      Notification.create!(user_id: uid, title: "IBITEGEREJE KWEMEZWA", body: "Kwishyura RWF #{amount} ku nguzanyo ##{loan.id}", kind: "repayment_request", is_read: false)
    end
    redirect_to dashboard_path, notice: "Ubwishyu bwoherejwe kuri Admin."
  end
end
