Rails.application.routes.draw do
  root "dashboard#index"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/dashboard", to: "dashboard#index"
  get "/health", to: "health#show"
end
