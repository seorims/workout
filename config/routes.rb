Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users

  # Root route
  root to: "pages#home"

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Workout Sessions Routes (Trainers can delete/cancel sessions)
  resources :workout_sessions, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
    member do
      patch :cancel # Trainers cancel sessions
    end
    resources :bookings, only: [:new, :create]
  end

  # Bookings Routes (Trainees cancel their bookings)
  resources :bookings, only: [:index, :destroy, :edit, :update] do
    member do
      patch :cancel # Trainees cancel bookings
      patch :update_status # Trainers confirm/cancel bookings
      patch :request_change  # New route for requesting changes to confirmed bookings
    end
  end
end
