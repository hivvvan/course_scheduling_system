FactoryBot.define do
  factory :student do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    sequence(:student_id) { |n| "ST#{format('%04d', n)}" }
    password { 'password123' }
    password_confirmation { 'password123' }
  end
end
