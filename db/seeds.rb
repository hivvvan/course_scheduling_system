# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Creating seed data..."

# Create Teachers
10.times do
  Teacher.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email
  )
end

# Create Subjects
subjects_data = [
  { code: "MATH101", name: "Calculus I" },
  { code: "CHEM101", name: "General Chemistry" },
  { code: "PHYS101", name: "Physics I" },
  { code: "CS101", name: "Introduction to Programming" },
  { code: "ENG101", name: "English Composition" }
]

subjects_data.each do |subject|
  Subject.create!(subject)
end

# Create Classrooms
buildings = [ "Science", "Engineering", "Liberal Arts" ]
3.times do |building_index|
  5.times do |room_number|
    Classroom.create!(
      building: buildings[building_index],
      room_number: "#{(room_number + 1) * 100}",
      capacity: rand(20..40)
    )
  end
end

# Create Students
5.times do |i|
  Student.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    student_id: "ST#{format('%04d', i+1)}",
    password: 'password123',
    password_confirmation: 'password123'
  )
end

# Create Sections
times = [
  { start: "08:00", end: "08:50" },
  { start: "09:00", end: "09:50" },
  { start: "10:00", end: "10:50" },
  { start: "13:00", end: "14:20" },
  { start: "14:30", end: "15:50" }
].map do |time|
  {
    start: Time.zone.parse(time[:start]),
    end: Time.zone.parse(time[:end])
  }
end

Subject.all.each do |subject|
  times.each do |time|
    Section.create!(
      teacher: Teacher.all.sample,
      subject: subject,
      classroom: Classroom.all.sample,
      start_time: time[:start],
      end_time: time[:end],
      monday: [ true, false ].sample,
      wednesday: [ true, false ].sample,
      friday: [ true, false ].sample,
      tuesday: [ true, false ].sample,
      thursday: [ true, false ].sample,
      capacity: rand(20..35),
      semester: "Fall",
      year: 2024
    )
  end
end

puts "Seed data created successfully!"
