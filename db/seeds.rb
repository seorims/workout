# this file ensures the existence of records required to run the application.
# it is idempotent and can be executed multiple times.

require 'faker'

# clear existing data to avoid duplication
Booking.destroy_all
WorkoutSession.destroy_all
User.destroy_all

# create trainers
trainers = 10.times.map do
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: "password", # provide a default password
    role: "Trainer",
    description: Faker::Job.title
  )
end

# create trainees
trainees = 10.times.map do
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: "password", # provide a default password
    role: "Trainee",
    description: Faker::Job.title
  )
end

puts "created #{trainers.count} trainers and #{trainees.count} trainees!"

# create workout sessions
workout_sessions = 10.times.map do
  WorkoutSession.create!(
    title: Faker::Educator.course_name,
    location: Faker::Address.community,
    duration: rand(30..90), # duration in minutes
    price: rand(15.0..50.0).round(2), # price in dollars
    desc: Faker::Lorem.sentence(word_count: 10), # use correct column name
    user_id: trainers.sample.id # assign a random trainer as the owner
  )
end

puts "created #{workout_sessions.count} workout sessions!"

# create bookings for trainees
workout_sessions.each do |workout|
  rand(5..15).times do
    Booking.create!(
      workout_session: workout,
      user: trainees.sample, # assign a random trainee
      status: "confirmed",
      start_time: Faker::Time.forward(days: 30, period: :morning)
    )
  end
end

puts "created bookings for workout sessions!"
