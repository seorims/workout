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
    password: "password", # default password
    role: "Trainer",
    description: Faker::Job.title
  )
end

# dreate trainees
trainees = 10.times.map do
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: "password", # default password
    role: "Trainee",
    description: Faker::Job.title
  )
end

puts "Created #{trainers.count} trainers and #{trainees.count} trainees!"

# create workout sessions
workout_sessions = 10.times.map do
  duration = [30, 45, 60, 90].sample # random duration in minutes
  sport = Faker::Sport.sport(include_ancient: true, include_unusual: true).titleize # random sport name with proper capitalisation

  WorkoutSession.create!(
    title: "#{duration} min of #{sport}",
    location: Faker::Address.community,
    duration: duration, # duration in minutes
    price: rand(15.0..50.0).round(2), # price in dollars
    desc: Faker::Lorem.sentence(word_count: 10), # description
    user_id: trainers.sample.id # assign a random trainer as the owner
  )
end

puts "Created #{workout_sessions.count} workout sessions!"

# create bookings for trainees
workout_sessions.each do |workout|
  rand(5..15).times do
    Booking.create!(
      workout_session: workout,
      user: trainees.sample, # assign a random trainee
      status: "confirmed",
      start_time: Faker::Time.forward(days: 30, period: :morning),
      booked_at: Time.now # set the booked_at field
    )
  end
end

puts "Created bookings for workout sessions!"
