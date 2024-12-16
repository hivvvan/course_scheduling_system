require 'rails_helper'

RSpec.describe Section, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }

    it 'validates section duration' do
      section = build(:section, start_time: "08:00", end_time: "09:00")
      expect(section).not_to be_valid
      expect(section.errors[:base]).to include("Section duration must be either 50 or 80 minutes")
    end

    it 'validates at least one day selected' do
      section = build(:section, monday: false, tuesday: false, wednesday: false, thursday: false, friday: false)
      expect(section).not_to be_valid
      expect(section.errors[:base]).to include("At least one day must be selected")
    end
  end

  describe 'associations' do
    it { should belong_to(:teacher) }
    it { should belong_to(:subject) }
    it { should belong_to(:classroom) }
    it { should have_many(:student_sections) }
    it { should have_many(:students).through(:student_sections) }
  end
end
