class Booking < ApplicationRecord
  belongs_to :workout_session
  belongs_to :user

  validates :booked_at, presence: true
  validates :status, inclusion: { in: ['pending', 'confirmed', 'cancelled'], message: "%{value} is not a valid status" }, allow_nil: true
  validates :start_time, presence: true
  validate :client_only_books_sessions

  private

  def client_only_books_sessions
    errors.add(:base, "Trainers cannot book sessions") if user&.role == 'trainer'
  end
end
