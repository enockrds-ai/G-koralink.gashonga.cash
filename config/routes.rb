Rails.application.routes.draw do
  root "dashboard#index"
  get "/login",to:"sessions#new"
  post "/login",to:"sessions#create"
  delete "/logout",to:"sessions#destroy"
  get "/dashboard",to:"dashboard#index"
  post "/savings",to:"savings#create"
  post "/loans",to:"loans#create"
  get "/admin",to:"admin#index"
  post "/admin/savings/:id/approve",to:"admin#approve_saving",as: :admin_approve_saving
  post "/admin/loans/:id/approve",to:"admin#approve_loan",as: :admin_approve_loan
  get "/health",to:"health#show"
end