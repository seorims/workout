class WorkoutSession < ApplicationRecord
  belongs_to :trainer, class_name: "User", foreign_key: "user_id"
  has_many :bookings
  has_many :trainees, through: :bookings, source: :user

  validate :trainer_only_creates_sessions

  private

  def trainer_only_creates_sessions
    errors.add(:base, "Only trainers can create sessions") unless trainer&.role == 'trainer'
  end
end
