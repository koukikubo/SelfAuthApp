Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "admin/login", to: "admin_sessions#create"
      post "staff/login", to: "staff_sessions#create"

      delete "logout", to: "sessions#destroy"
      
      get "csrf", to: "csrf#show" 
    end
  end
end
