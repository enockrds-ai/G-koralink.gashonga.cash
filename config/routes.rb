Rails.application.routes.draw do
  root "dashboard#index"
  get "/login",to:"sessions#new"
  post "/login",to:"sessions#create"
  delete "/logout",to:"sessions#destroy"
  get "/register",to:"registrations#new"
  post "/register",to:"registrations#create"
  get "/dashboard",to:"dashboard#index"
  post "/savings",to:"savings#create"
  post "/loans",to:"loans#create"
  post "/repayments",to:"repayments#create"
  get "/members",to:"members#index"
  get "/admin",to:"admin#index"
  post "/admin/members/:id/approve",to:"admin#approve_member",as: :admin_approve_member
  post "/admin/members/:id/reject",to:"admin#reject_member",as: :admin_reject_member
  post "/admin/savings/:id/approve",to:"admin#approve_saving",as: :admin_approve_saving
  post "/admin/savings/:id/reject",to:"admin#reject_saving",as: :admin_reject_saving
  post "/admin/loans/:id/approve",to:"admin#approve_loan",as: :admin_approve_loan
  post "/admin/loans/:id/reject",to:"admin#reject_loan",as: :admin_reject_loan
  get "/health",to:"health#show"
end