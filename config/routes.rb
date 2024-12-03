Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  resources :teachers
  resources :subjects
  resources :classrooms
  resources :sections

  namespace :student do
    resource :schedule, only: [ :show ] do
      post "add_section/:section_id", to: "schedules#add_section", as: :add_section
      delete "remove_section/:section_id", to: "schedules#remove_section", as: :remove_section
      get "download_pdf", to: "schedules#download_pdf", as: :download_pdf
    end
  end
end
