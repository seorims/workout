require 'httparty'
require 'open-uri'
require 'faker'

# Clear data
Booking.destroy_all
WorkoutSession.destroy_all
User.destroy_all

# Unsplash setup
UNSPLASH_ACCESS_KEY = ENV['UNSPLASH_ACCESS_KEY']

def fetch_unsplash_image(sport)
  response = HTTParty.get("https://api.unsplash.com/photos/random?query=#{sport}&client_id=#{UNSPLASH_ACCESS_KEY}")
  if response.success? ? response.parsed_response["urls"]["regular"] : nil
  else
  nil
  end
end

# Create admin accounts
admin_trainer = User.create!(
 name: "Admin trainer",
 email: "trainer@admin.com",
 password: "123456",
 role: "trainer",
 description: "Admin trainer for testing/debugging"
)
admin_trainer.photo.attach(io: URI.open("https://api.dicebear.com/7.x/avataaars/svg?seed=#{admin_trainer.name}"), filename: "admin_trainer.svg")

admin_trainee = User.create!(
 name: "Admin trainee",
 email: "trainee@admin.com",
 password: "123456",
 role: "trainee"
)
admin_trainee.photo.attach(io: URI.open("https://api.dicebear.com/7.x/avataaars/svg?seed=#{admin_trainee.name}"), filename: "admin_trainee.svg")

# Create realistic trainers
realistic_trainers = [
  { name: "Nico Chu", email: "nico.chu@trainer.com", desc: "Ever heard of cheese rolling?" },
  { name: "Sarah Potter", email: "sarah.potter@trainer.com", desc: "I love cheese rolling." },
  { name: "Rayz Arain", email: "rayz.arain@trainer.com", desc: "A lifelong athlete with a deep love for movement and self-improvement. Specializes in badminton, flexibility training, and functional fitness." },
  { name: "Julian Cass", email: "julian.cass@trainer.com", desc: "An endurance sports enthusiast who believes in discipline and long-term progress. Focuses on strength training and conditioning for longevity." },
  { name: "Lio Catalan", email: "lio.catalan@trainer.com", desc: "A firm believer in the connection between physical and mental endurance. Specializes in bodyweight training, balance, and core strength." },
  { name: "Sarah Chu", email: "sarah.chu@trainer.com", desc: "A dynamic fitness coach with a love for high-energy workouts. Experienced in group fitness, agility drills, and dance-inspired cardio training." },
  { name: "Liam Gingell", email: "liam.gingell@trainer.com", desc: "A movement specialist who transitioned from music to fitness, emphasizing rhythm and flow. Teaches functional mobility and body coordination." },
  { name: "Ruben Hedstrom", email: "ruben.hedstrom@trainer.com", desc: "A performance-driven coach combining athletic training with scientific precision. Expertise in strength training, speed, and power development." },
  { name: "Amy Huang", email: "amy.huang@trainer.com", desc: "A passionate advocate for sports that challenge both mind and body. Specializes in dance fitness, flexibility, and high-intensity workouts." },
  { name: "Cindy Mae Ngoho", email: "cindy.ngoho@trainer.com", desc: "From teaching to training, she brings an analytical approach to fitness. Focuses on weightlifting, body mechanics, and injury prevention." },
  { name: "Jakub Ohkado", email: "jakub.ohkado@trainer.com", desc: "An advocate for holistic strength and conditioning, combining structured training with a hands-on coaching style for all fitness levels." },
  { name: "Ben Pearson", email: "ben.pearson@trainer.com", desc: "A firm believer in movement as a lifelong pursuit. Specializes in endurance training, kettlebells, and functional movement." },
  { name: "Maximilian Schopf", email: "max.schopf@trainer.com", desc: "A meticulous trainer who values precision and technique. Expert in calisthenics, flexibility, and injury prevention strategies." },
  { name: "Allan Sechrist", email: "allan.sechrist@trainer.com", desc: "A strong proponent of strength training for all ages. Focuses on progressive overload, muscle control, and longevity in fitness." },
  { name: "Stamatios Stamatiou", email: "stamatiou@trainer.com", desc: "A performance coach with a keen eye for biomechanics. Specializes in strength development and bodyweight mastery." },
  { name: "Jasmine Stivers", email: "jasmine.stivers@trainer.com", desc: "An expert in efficient, minimalist training methods. Focuses on movement efficiency, balance, and flexibility." },
  { name: "Minami Takayama", email: "minami.takayama@trainer.com", desc: "A disciplined coach with experience in endurance sports. Specializes in marathon training, agility, and breathwork techniques." },
  { name: "Miyabi Tasaki", email: "miyabi.tasaki@trainer.com", desc: "A fitness enthusiast who approaches training with curiosity and passion. Focuses on foundational strength and body control." },
  { name: "Alexander Wong", email: "alex.wong@trainer.com", desc: "A versatile trainer with experience in multiple disciplines. Specializes in flexibility, mobility, and explosive power development." }
].map do |trainer|
 user = User.create!(
   name: trainer[:name],
   email: trainer[:email],
   password: "password",
   role: "trainer",
   description: trainer[:desc]
 )
 user.photo.attach(io: URI.open("https://api.dicebear.com/7.x/avataaars/svg?seed=#{user.name}"), filename: "#{user.name.parameterize}.svg")
 user
end

# Create realistic trainees with photos
realistic_trainees = [
  { name: "Emma Davis", email: "emma.d@gmail.com" },
  { name: "James Wilson", email: "james.w@gmail.com" },
  { name: "Lisa Anderson", email: "lisa.a@gmail.com" }
].map do |trainee|
 user = User.create!(
   name: trainee[:name],
   email: trainee[:email],
   password: "password",
   role: "trainee"
 )
 user.photo.attach(io: URI.open("https://api.dicebear.com/7.x/avataaars/svg?seed=#{user.name}"), filename: "#{user.name.parameterize}.svg")
 user
end

realistic_sessions = [
  {title: "High Intensity Interval Training", location: "Downtown Gym", duration: 45, price: 35, desc: "Full body workout combining cardio and strength training"},
  {title: "Power Yoga Flow", location: "Zen Studio", duration: 60, price: 25, desc: "Dynamic yoga sequence focusing on strength and flexibility"},
  {title: "Olympic Weightlifting Basics", location: "Strength Hub", duration: 90, price: 45, desc: "Learn proper form for snatch and clean & jerk"}
]

# Create realistic sessions with photos
realistic_sessions.each do |session|
 workout = WorkoutSession.create!(
   title: session[:title],
   location: session[:location],
   duration: session[:duration],
   price: session[:price],
   desc: session[:desc],
   user_id: realistic_trainers.sample.id
 )

 begin
   if image_url = fetch_unsplash_image(session[:title])
     file = URI.open(image_url)
     workout.photo.attach(io: file, filename: "#{session[:title].parameterize}.jpg", content_type: "image/jpeg")
   end
 rescue OpenURI::HTTPError => e
   puts "Failed to attach image for #{session[:title]}: #{e.message}"
 end
end

# Create faker sessions with photos
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
 sport = Faker::Sport.sport(include_ancient: true, include_unusual: true).titleize

 workout = WorkoutSession.create!(
   title: "#{duration} min of #{sport}",
   location: Faker::Address.community,
   duration: duration,
   price: rand(15..50).round(2),
   desc: descriptions.sample,
   user_id: realistic_trainers.sample.id
 )

 begin
   if image_url = fetch_unsplash_image(sport)
     file = URI.open(image_url)
     workout.photo.attach(io: file, filename: "#{sport.downcase}.jpg", content_type: "image/jpeg")
   end
 rescue OpenURI::HTTPError => e
   puts "Failed to attach image for #{sport}: #{e.message}"
 end
end

# Create bookings
WorkoutSession.all.each do |workout|
 rand(5..15).times do
   Booking.create!(
     workout_session: workout,
     user: realistic_trainees.sample,
     status: "confirmed",
     start_time: Time.current + rand(1..30).days,
     booked_at: Time.now
   )
 end
end
