FactoryBot.define do
  factory :subject do
    sequence(:code) { |n| "SUBJ#{n}" }
    name { Faker::Educator.course_name }
    description { Faker::Lorem.paragraph }
  end
end
