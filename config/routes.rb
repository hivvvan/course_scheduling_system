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

  # Mount PgHero dashboard
  mount PgHero::Engine, at: "pghero"

  # Add Devise routes for students
  devise_for :students, path: "", path_names: {
    sign_in: "login",
    sign_out: "logout",
    registration: "register"
  }

  resources :sections, only: [:index]

  namespace :student do
    resource :schedule, only: [ :show ] do
      get :export, on: :member, defaults: { format: "pdf" }
    end

    resources :enrollments, only: [:create, :destroy]
  end

  # Add root route
  authenticated :student do
    root "student/schedules#show", as: :authenticated_root
  end

  resources :dashboard, only: [:index]
  root 'dashboard#index'
end
