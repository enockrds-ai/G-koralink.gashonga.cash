class SavingsController < ApplicationController
  def create
    member=Member.find_by(user_id:current_user.id); amount=params[:amount].to_i
    now=Time.current; rwanda=now.in_time_zone("Africa/Kigali"); wday=rwanda.wday; hour=rwanda.hour
    allowed=(wday==2 && hour>=5 && hour<8) || (wday==3 && (hour<15))
    week_start=(rwanda.to_date-(rwanda.wday==0 ? 4 : (rwanda.wday-3)%7))
    weekly=Saving.where(member_id:member&.id).where(created_at:week_start.beginning_of_day..rwanda.end_of_day).sum(:amount)
    if member.nil? then msg="Umunyamuryango ntabashije kuboneka."
    elsif !allowed then msg="Kwizigama bikorwa kuwa Kabiri 05:00–08:00 cyangwa kuwa Gatatu mbere ya 15:00."
    elsif amount<=0 || amount%500!=0 then msg="Amafaranga agomba kuba multiple ya 500."
    elsif weekly+amount>4000 then msg="Ntushobora kurenza shares 8 (RWF 4,000) muri iki cyumweru."
    else
      Saving.create!(member_id:member.id,amount:amount,status:"pending",note:params[:note].to_s,share_count:amount/500)
      redirect_to dashboard_path,notice:"Ubwizigame bwoherejwe gutegereza Admin."; return
    end
    redirect_to dashboard_path,alert:msg
  end
end