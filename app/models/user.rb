class User < ApplicationRecord
  has_many :workout_sessions
  has_many :bookings
end

# to simulate pull request
