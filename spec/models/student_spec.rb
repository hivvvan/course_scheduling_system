require 'rails_helper'

RSpec.describe Student, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:student_id) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_uniqueness_of(:student_id) }
  end

  describe 'associations' do
    it { should have_many(:student_sections) }
    it { should have_many(:sections).through(:student_sections) }
  end

  describe '#can_enroll_in_section?' do
    let(:student) { create(:student) }
    let(:section1) { create(:section, start_time: "08:00", end_time: "08:50", monday: true) }
    let(:section2) { create(:section, start_time: "08:00", end_time: "08:50", monday: true) }
    let(:section3) { create(:section, start_time: "09:00", end_time: "09:50", monday: true) }

    before do
      student.sections << section1
    end

    it 'returns false for overlapping sections' do
      expect(student.can_enroll_in_section?(section2)).to be false
    end

    it 'returns true for non-overlapping sections' do
      expect(student.can_enroll_in_section?(section3)).to be true
    end
  end
end
