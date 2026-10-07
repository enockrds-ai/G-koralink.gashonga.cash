class RegistrationsController < ApplicationController
  skip_before_action :require_login, only: [:new,:create]
  def new; end
  def create
    phone=params[:phone].to_s.gsub(/\D/,""); name=params[:display_name].to_s.strip; pass=params[:password].to_s
    if phone.length!=10 || name.blank? || !pass.match?(/\A\d{5}\z/)
      redirect_to register_path,alert:"Amazina, telefoni y'imibare 10 na passcode y'imibare 5 birakenewe."; return
    end
    if Member.joins(:user).where(phone:phone).exists?
      redirect_to register_path,alert:"Iyi telefoni isanzwe iri muri system."; return
    end
    group=Group.first
    user=User.create!(email:"member-#{phone}@gkoralink.local",display_name:name,role:"member")
    UserPassword.create!(user_id:user.id,password_hash:BCrypt::Password.create(pass,cost:12).to_s)
    member=Member.create!(user_id:user.id,group_id:group.id,display_name:name,phone:phone,status:"pending",code:"GK-#{rand(100000..999999)}")
    User.where(role:"admin").pluck(:id).each{|uid| Notification.create!(user_id:uid,title:"IBITEGEREJE KWEMEZWA",body:"Umunyamuryango mushya: #{name} — #{phone}",kind:"member_request",is_read:false)}
    redirect_to login_path,notice:"Konti yakozwe. Tegereza Admin ayemeze."
  rescue ActiveRecord::RecordInvalid=>e
    redirect_to register_path,alert:e.message
  end
end
