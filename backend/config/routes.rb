Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "admin/login", to: "admin_sessions#create"
      post "staff/login", to: "staff_sessions#create"
      get "session", to: "sessions#show"
      delete "logout", to: "sessions#destroy"

      get "csrf", to: "csrf#show" 

      get "login_candidates", to: "login_candidates#index"
      resources :staffs, only: [:index, :create, :update, :destroy] do
        patch :account_unlock, on: member
        patch :account_lock, on: member          
      end
    end
  end
end
