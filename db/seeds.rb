require 'faker'

# clear existing data
Booking.destroy_all
WorkoutSession.destroy_all
User.destroy_all

# create realistic trainers
realistic_trainers = [
 {name: "Sarah Chu", email: "sc@trainer.com", desc: "NASM Certified Personal Trainer, 10+ years experience"},
 {name: "Lio Catalan", email: "ls@trainer.com", desc: "Yoga Alliance Certified, Specialized in Vinyasa Flow"},
 {name: "Nico Nico", email: "nn@trainer.com", desc: "NASA Engineer Scarecrow"}
].map do |trainer|
 User.create!(
   name: trainer[:name],
   email: trainer[:email],
   password: "password",
   role: "Trainer",
   description: trainer[:desc]
 )
end

# create realistic trainees
realistic_trainees = [
 {name: "Emma Davis", email: "emma.d@gmail.com"},
 {name: "James Wilson", email: "james.w@gmail.com"},
 {name: "Lisa Anderson", email: "lisa.a@gmail.com"}
].map do |trainee|
 User.create!(
   name: trainee[:name],
   email: trainee[:email],
   password: "password",
   role: "Trainee"
 )
end

# create realistic sessions first
realistic_sessions = [
 {title: "High Intensity Interval Training", location: "Downtown Gym", duration: 45, price: 35.00, desc: "Full body workout combining cardio and strength training"},
 {title: "Power Yoga Flow", location: "Zen Studio", duration: 60, price: 25.00, desc: "Dynamic yoga sequence focusing on strength and flexibility"},
 {title: "Olympic Weightlifting Basics", location: "Strength Hub", duration: 90, price: 45.00, desc: "Learn proper form for snatch and clean & jerk"}
].map do |session|
 WorkoutSession.create!(
   title: session[:title],
   location: session[:location],
   duration: session[:duration],
   price: session[:price],
   desc: session[:desc],
   user_id: realistic_trainers.sample.id
 )
end

puts "Created #{realistic_sessions.count} realistic sessions"

# create faker trainers
trainers = 10.times.map do
 User.create!(
   name: Faker::Name.name,
   email: Faker::Internet.email,
   password: "password",
   role: "Trainer",
   description: Faker::Job.title
 )
end

# create faker trainees
trainees = 10.times.map do
 User.create!(
   name: Faker::Name.name,
   email: Faker::Internet.email,
   password: "password",
   role: "Trainee",
   description: Faker::Job.title
 )
end

puts "Created #{trainers.count} faker trainers and #{trainees.count} faker trainees"

# create faker workout sessions with better descriptions
10.times do
 duration = [30, 45, 60, 90].sample
 sport = Faker::Sport.sport(include_ancient: true, include_unusual: true).titleize

 descriptions = [
   "#{duration}-minute session focused on proper #{sport} technique and conditioning. Suitable for all skill levels.",
   "Join us for #{duration} minutes of #{sport}. Build skills while improving overall fitness.",
   "Master the fundamentals of #{sport} in this #{duration}-minute class. All experience levels welcome.",
   "Elevate your #{sport} game with this #{duration}-minute training session. From basics to advanced techniques.",
   "#{duration}-minute #{sport} workout combining skill development with physical conditioning.",
   "Get fit through #{sport} in this #{duration}-minute class. Technical drills and cardio combined.",
   "Immersive #{duration}-minute #{sport} session. Focus on form, strategy, and conditioning.",
   "#{sport} fundamentals and beyond in #{duration} minutes. Progress at your own pace."
 ]

 WorkoutSession.create!(
   title: "#{duration} min of #{sport}",
   location: Faker::Address.community,
   duration: duration,
   price: rand(15.0..50.0).round(2),
   desc: descriptions.sample,
   user_id: trainers.sample.id
 )
end

total_sessions = WorkoutSession.count
puts "Total sessions created: #{total_sessions}"

# create bookings
WorkoutSession.all.each do |workout|
 rand(5..15).times do
   Booking.create!(
     workout_session: workout,
     user: trainees.sample,
     status: "confirmed",
     start_time: Faker::Time.forward(days: 30, period: :morning)
   )
 end
end

puts "Created bookings for all sessions!"
