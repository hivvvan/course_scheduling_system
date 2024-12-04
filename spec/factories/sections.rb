FactoryBot.define do
  factory :section do
    association :teacher
    association :subject
    association :classroom
    start_time { Time.zone.parse("08:00") }
    end_time { Time.zone.parse("08:50") }
    capacity { 30 }
    semester { "Fall" }
    year { 2024 }

    trait :with_days do
      monday { true }
      wednesday { true }
      friday { true }
    end
  end
end
