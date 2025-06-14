require "sidekiq/web" # require the web UI
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  
  namespace :api do
    get '/card', to: 'cards#show'
    put '/card', to: 'cards#update'
    get '/admin/stock', to: 'admin#stock'
    get '/admin/finances', to: 'admin#finances'
  end

  mount Sidekiq::Web => "/sidekiq" # access it at http://localhost:3000/sidekiq
  

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
