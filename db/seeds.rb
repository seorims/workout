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
puts "Cleaning database"
Booking.destroy_all
WorkoutSession.destroy_all
User.destroy_all

puts "Database cleaned"
# Old seeds might cause an error whenever databased is updated

require 'faker'
10.times do
  user = User.create(
    name: Faker::Name.name,         # This generates a random name
    role: "Trainer",                # All of them are trainers
    description: Faker::Job.title, # This generates a random job description
    email: Faker::Internet.email,
    password: "1234567"
    )
  puts "Trainer created - #{user.id}"
end

# create trainee
30.times do
  user = User.create(
    name: Faker::Name.name,         # This generates a random name
    role: "Trainee",                # All of them are trainees
    description: Faker::Job.title, # This generates a random job description
    email: Faker::Internet.email,
    password: "1234567"
  )
  puts "Trainee created - #{user.id}"
end

trainees = User.where(role: "Trainee")
trainers = User.where(role: "Trainer")

# create workout session
10.times do
  workout = WorkoutSession.create(
    title: Faker::Educator.course_name, # Random session titles
    location: Faker::Address.community, # Random location
    duration: rand(30..90), # Random duration between 30 and 90 minutes
    price: rand(15.0..50.0).round(2), # Random price between $15.00 and $50.00
    desc: Faker::Lorem.sentence(word_count: 10), # Random description
    user_id: trainers.sample.id # Assign a random trainer
  )
  puts "Workout session created - #{workout.id}"
end

workouts = WorkoutSession.all

# create booking
10.times do
booking = Booking.create(
  workout_session_id: workouts.sample.id,
  user_id: trainees.sample.id,
  status: "Confirmed",
  start_time: Time.now
  )
  puts "Booking created - #{booking.id}"
end
