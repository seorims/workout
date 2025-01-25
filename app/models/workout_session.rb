class WorkoutSession < ApplicationRecord
  belongs_to :trainer, class_name: "User", foreign_key: "user_id"
  has_many :bookings
  has_many :trainees, through: :bookings, source: :user

  def start_time
    bookings.first&.start_time
  end
end
