class SavingsController < ApplicationController
  def create
    member=Member.find_by(user_id:current_user.id)
    amount=params[:amount].to_i
    now=Time.now.in_time_zone("Africa/Kigali")
    valid_window=(now.wday==2 && now.hour.between?(5,7)) || (now.wday==3 && (now.hour<15))
    week_start=now.to_date - ((now.wday-3)%7)
    weekly=member ? Saving.where(member_id:member.id).where(created_at:week_start.beginning_of_day..now.end_of_day).sum(:amount).to_i : 0
    if member.nil?
      redirect_to dashboard_path,alert:"Ntabwo uri umunyamuryango."; return
    elsif !valid_window
      redirect_to dashboard_path,alert:"Kwizigama bikorwa Ku wa Kabiri 05:00–08:00 cyangwa Ku wa Gatatu mbere ya 15:00."; return
    elsif amount<=0 || amount%500!=0
      redirect_to dashboard_path,alert:"Amafaranga agomba kuba multiple ya 500."; return
    elsif weekly+amount>4000
      redirect_to dashboard_path,alert:"Nturenze imigabane 8 (RWF 4,000) mu cyumweru."; return
    end
    Saving.create!(member_id:member.id,amount:amount,status:"pending",note:params[:note].to_s,share_count:amount/500)
    User.where(role:"admin").pluck(:id).each{|uid| Notification.create!(user_id:uid,title:"IBITEGEREJE KWEMEZWA",body:"Ubwizigame bwa RWF #{amount} busabye kwemezwa.",kind:"saving_request",is_read:false)}
    redirect_to dashboard_path,notice:"Ubwizigame bwoherejwe gutegereza Admin."
  end
end
