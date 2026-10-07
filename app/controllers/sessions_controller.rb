class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new,:create]
  def new; end
  def create
    user=User.find_by(email:params[:email].to_s.strip.downcase)
    hash=user&.password_digest
    if user && hash.present? && BCrypt::Password.new(hash)==params[:password].to_s && (user.role.to_s=="admin" || user.member&.status.to_s=="active")
      session[:user_id]=user.id; redirect_to dashboard_path
    else
      flash.now[:alert]="Email cyangwa passcode si byo, cyangwa konti ntiraremezwa."; render :new,status: :unprocessable_entity
    end
  end
  def destroy; reset_session; redirect_to login_path; end
end