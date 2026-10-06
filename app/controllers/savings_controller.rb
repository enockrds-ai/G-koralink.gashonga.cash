class SavingsController < ApplicationController
  def create
    member = Member.find_by(user_id: current_user.id)
    amount = params[:amount].to_i
    if member.nil? || amount <= 0 || amount % 500 != 0
      redirect_to dashboard_path, alert: "Amafaranga agomba kuba ari multiple ya 500."
      return
    end
    Saving.create!(member_id: member.id, amount: amount, status: "pending", note: params[:note].to_s, share_count: amount / 500)
    redirect_to dashboard_path, notice: "Ubwizigame bwoherejwe gutegereza Admin."
  end
end
