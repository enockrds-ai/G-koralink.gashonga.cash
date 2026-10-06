class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  def new; end
  def create
    user = User.find_by(email: params[:email].to_s.strip.downcase)
    if user && user.password_digest.present? && BCrypt::Password.new(user.password_digest) == params[:password].to_s
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      flash.now[:alert] = "Email cyangwa passcode si byo."
      render :new, status: :unprocessable_entity
    end
  end
  def destroy
    reset_session
    redirect_to login_path
  end
end
