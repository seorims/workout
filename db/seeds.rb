# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# create trainer
trainer = User.create(name: "Tanaka Taro", role: "Trainer", description: "Expert fitness coach")

# create trainee
trainee = User.create(name: "Sato Hanako", role: "Trainee", description: "Loves fitness classes")

# create workout session
workout = WorkoutSession.create(
  title: "Morning Yoga",
  location: "Studio A",
  duration: 60,
  price: 20.0,
  desc: "A relaxing yoga session to start your day.",
  trainer: trainer
)

# create booking
Booking.create(workout_session: workout, user: trainee, status: "confirmed", start_time: Time.now)
