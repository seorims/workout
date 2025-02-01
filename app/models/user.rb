class User < ApplicationRecord
  # trainer relationship
  has_many :workout_sessions, foreign_key: "user_id"

  # trainee relationship
  has_many :bookings
  has_many :attended_workouts, through: :bookings, source: :workout_session


  # devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # validations
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :role, inclusion: { in: ['trainer', 'trainee'] }

  has_one_attached :photo

  def avatar_url
    # uses ui-avatars api as fallback for all users
    "https://ui-avatars.com/api/?name=#{name || 'User'}"
  end
end
