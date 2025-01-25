class Booking < ApplicationRecord
  belongs_to :workout_session
  belongs_to :user

  validates :booked_at, presence: true
  validates :status, inclusion: { in: ['pending', 'confirmed', 'cancelled'], message: "%{value} is not a valid status" }, allow_nil: true
  validates :start_time, presence: true
end
