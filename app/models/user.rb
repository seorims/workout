class User < ApplicationRecord
  # trainer relationship
  has_many :workout_sessions, foreign_key: "user_id", class_name: "WorkoutSession"

  # trainee relationship (via bookings)
  has_many :bookings
  has_many :attended_workouts, through: :bookings, source: :workout_session

  # devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def avatar_url
    # uses ui-avatars api as fallback for all users
    "https://ui-avatars.com/api/?name=#{name || 'User'}"
  end
end
