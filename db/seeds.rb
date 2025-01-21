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

require 'faker'
trainers = 10.times.map do
  User.create(
    name: Faker::Name.name,         # This generates a random name
    role: "Trainer",                # All of them are trainers
    description: Faker::Job.title # This generates a random job description
  )
end

# create trainee
trainees = 100.times.map do
  User.create(
    name: Faker::Name.name,         # This generates a random name
    role: "Trainee",                # All of them are trainees
    description: Faker::Job.title # This generates a random job description
  )
end

puts "Created 10 trainers and 100 trainees!"

# create workout session
10.times do
  WorkoutSession.create(
    title: Faker::Educator.course_name, # Random session titles
    location: Faker::Address.community, # Random location
    duration: rand(30..90), # Random duration between 30 and 90 minutes
    price: rand(15.0..50.0).round(2), # Random price between $15.00 and $50.00
    desc: Faker::Lorem.sentence(word_count: 10), # Random description
    trainer: trainers.sample # Assign a random trainer
  )
end

# create booking
Booking.create(workout_session: workout, user: trainee, status: "confirmed", start_time: Time.now)
