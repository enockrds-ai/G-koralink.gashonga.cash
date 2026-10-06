class HealthController < ActionController::API
  def show
    render json: {status: "ok", app: "G-KORALINK"}
  end
end
