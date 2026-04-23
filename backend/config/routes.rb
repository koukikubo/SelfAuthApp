Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "login", to: "sessions#create"
      delete "logout", to: "sessions#destroy"   
      get "csrf", to: "csrf#show" 
    end
  end
end
