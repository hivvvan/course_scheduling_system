FactoryBot.define do
  factory :classroom do
    building { [ "Science", "Engineering", "Liberal Arts" ].sample }
    sequence(:room_number) { |n| "#{n}01" }
    capacity { rand(20..40) }
  end
end
