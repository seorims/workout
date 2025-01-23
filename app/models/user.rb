class User < ApplicationRecord

  # trainer relationship
  has_many :workout_sessions, foreign_key: "user_id", class_name: "WorkoutSession"

  # trainee relationship (via bookings)
  has_many :bookings
  has_many :attended_workouts, through: :bookings, source: :workout_session
   # include default devise modules. note to self, others are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
