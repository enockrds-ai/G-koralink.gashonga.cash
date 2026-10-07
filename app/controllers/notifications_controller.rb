class NotificationsController < ApplicationController
  def index
    @notifications=Notification.where(user_id:current_user.id).order(created_at: :desc).limit(100)
  end
  def read
    n=Notification.find_by(id:params[:id],user_id:current_user.id); n&.update(is_read:true)
    redirect_to notifications_path
  end
end
