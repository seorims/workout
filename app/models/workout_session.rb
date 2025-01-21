class WorkoutSession < ApplicationRecord
  belongs_to :user
  has_many :bookings
end

# to simulate pull request
