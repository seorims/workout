class WorkoutSession < ApplicationRecord
  belongs_to :trainer, class_name: "User", foreign_key: "user_id"
  has_many :bookings
  has_many :trainees, through: :bookings, source: :user
end
# start_time is determined by user (trainee) during booking, so start_time has been removed. it is now unnecessary to set a default start_time if the responsibility for setting it has shifted to the Booking model.
