Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Root route
  root to: "pages#home"

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Sessions routes
  resources :workout_sessions, only: [:index, :show] do
    # Nested bookings routes for session-specific actions
    resources :bookings, only: [:create]
  end

  # Bookings routes
  resources :bookings, only: [:index, :show, :update, :destroy]
end
