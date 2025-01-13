Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  devise_for :users
  resources :listings
 resources :chat_rooms
  resources :messages, only: [:create, :destroy]
  resources :listings do
    collection do
      get :search
    end
     resources :chat_rooms
    resources :comments, only: :create
  end
  resources :users do
    resources :ratings, only: :create
  end
  resources :chat_rooms do
    resources :messages, only: [:create]
  end
  resources :listings do
    resources :ratings, only: :create
  end

  root "listings#index"
end
