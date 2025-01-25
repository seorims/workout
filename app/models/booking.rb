class Booking < ApplicationRecord
  belongs_to :workout_session
  belongs_to :user

  validates :booked_at, presence: true
  validates :status, inclusion: { in: ['pending', 'confirmed', 'cancelled'], message: "%{value} is not a valid status" }, allow_nil: true
end

# to simulate pull request
# to simulate merge
# test
