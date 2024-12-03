FactoryBot.define do
  factory :section do
    association :teacher
    association :subject
    association :classroom
    start_time { "08:00" }
    end_time { "08:50" }
    monday { true }
    wednesday { true }
    friday { true }
    capacity { 30 }
    semester { "Fall" }
    year { 2024 }
  end
end