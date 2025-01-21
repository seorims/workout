class Booking < ApplicationRecord
  belongs_to :workout_session
  belongs_to :user
end

# to simulate pull request
