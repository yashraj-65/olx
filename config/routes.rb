Rails.application.routes.draw do
  use_doorkeeper
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  root "items#index"
  resources :items, only: [:new, :create, :show, :index, :destroy, :edit, :update] do
    resources :likes  
  end
  resources :likes, only: [:index]

  resources :conversations do 
    resources :messages
    resources :deals, only: [:create, :update]
  end
  resources :reviews do
  member do
  post 'like_review', to: 'likes#like_review'
  end
end
resources :deals do
  resources :reviews do
    
      post 'create_review', on: :collection
    
  end
end 
resources :sellers
resources :likes

namespace :api, defaults: { format: :json } do
  namespace :v1 do
    resources :items, only: [:index, :show, :destroy, :update, :create]
    resources :users, only: [:index, :show, :create,:update, :destroy]
    resources :deals, only: [:index, :show] do
        member do
          patch :mark_sold
        end
    end
    resources :reviews, only: [:index, :show, :destroy]
    resources :likes, only: [:index, :show, :destroy, :create]
    resources :conversations, only: [:index, :show,:update]
    resources :sellers, only: [:index, :show, :update]
  end
end

end
