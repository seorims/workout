class WorkoutSession < ApplicationRecord
  belongs_to :trainer, class_name: "User", foreign_key: "user_id"
  has_many :bookings
  has_many :trainees, through: :bookings, source: :user

  validates :start_time, presence: true

  before_validation :set_default_start_time, on: :create

  private

  def set_default_start_time
    self.start_time ||= Time.now.in_time_zone('Tokyo') + 1.day
  end
end
