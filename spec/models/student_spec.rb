require 'rails_helper'

RSpec.describe Student, type: :model do
  describe 'validations' do
    let!(:student) { create(:student) }

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:student_id) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_uniqueness_of(:student_id) }
  end

  describe 'associations' do
    it { should have_many(:student_sections) }
    it { should have_many(:sections).through(:student_sections) }
  end

  describe '#can_enroll_in_section?' do
    let(:student) { create(:student) }

    # 50-minute sections
    let(:mon_8am) { create(:section, start_time: "8:00 AM", end_time: "8:50 AM", monday: true) }
    let(:mon_9am) { create(:section, start_time: "9:00 AM", end_time: "9:50 AM", monday: true) }
    let(:wed_8am) { create(:section, start_time: "8:00 AM", end_time: "8:50 AM", wednesday: true) }

    # 80-minute sections
    let(:mon_10am_long) { create(:section, start_time: "10:00 AM", end_time: "11:20 AM", monday: true) }
    let(:tue_1pm_long) { create(:section, start_time: "1:00 PM", end_time: "2:20 PM", tuesday: true) }
    let(:multi_day) { create(:section, start_time: "8:00 AM", end_time: "8:50 AM", monday: true, wednesday: true) }

    context 'when student has no enrolled sections' do
      it 'returns true for any valid section' do
        expect(student.can_enroll_in_section?(mon_8am)).to be true          # 50-min
        expect(student.can_enroll_in_section?(mon_10am_long)).to be true    # 80-min
      end
    end

    context 'when student is enrolled in a 50-minute Monday 8 AM section' do
      before { student.sections << mon_8am }

      it 'returns false for same time on same day' do
        duplicate_section = create(:section, start_time: "8:00 AM", end_time: "8:50 AM", monday: true)
        expect(student.can_enroll_in_section?(duplicate_section)).to be false
      end

      it 'returns true for same time on different day' do
        expect(student.can_enroll_in_section?(wed_8am)).to be true
      end

      it 'returns true for non-overlapping time on same day' do
        expect(student.can_enroll_in_section?(mon_9am)).to be true
      end

      it 'returns false for overlapping 80-minute section' do
        overlapping_long = create(:section, start_time: "8:30 AM", end_time: "9:50 AM", monday: true)
        expect(student.can_enroll_in_section?(overlapping_long)).to be false
      end
    end

    context 'when student is enrolled in an 80-minute section' do
      before { student.sections << mon_10am_long }

      it 'returns false for overlapping 50-minute section' do
        conflict_50min = create(:section, start_time: "11:00 AM", end_time: "11:50 AM", monday: true)
        expect(student.can_enroll_in_section?(conflict_50min)).to be false
      end

      it 'returns false for overlapping 80-minute section' do
        conflict_80min = create(:section, start_time: "10:30 AM", end_time: "11:50 AM", monday: true)
        expect(student.can_enroll_in_section?(conflict_80min)).to be false
      end

      it 'returns true for back-to-back 80-minute section' do
        next_section = create(:section, start_time: "11:20 AM", end_time: "12:40 PM", monday: true)
        expect(student.can_enroll_in_section?(next_section)).to be true
      end
    end

    context 'with multiple enrolled sections of different durations' do
      before do
        student.sections << mon_8am          # 50-minute section
        student.sections << tue_1pm_long     # 80-minute section
      end

      it 'returns true when no conflicts with either section type' do
        wed_3pm = create(:section, start_time: "3:00 PM", end_time: "3:50 PM", wednesday: true)
        expect(student.can_enroll_in_section?(wed_3pm)).to be true
      end

      it 'returns false when conflicts with 50-minute section' do
        conflict = create(:section, start_time: "8:00 AM", end_time: "8:50 AM", monday: true)
        expect(student.can_enroll_in_section?(conflict)).to be false
      end

      it 'returns false when conflicts with 80-minute section' do
        conflict = create(:section, start_time: "1:30 PM", end_time: "2:50 PM", tuesday: true)
        expect(student.can_enroll_in_section?(conflict)).to be false
      end
    end

    context 'edge cases with valid durations' do
      it 'handles consecutive 50-minute sections' do
        early_section = create(:section, start_time: "9:00 AM", end_time: "9:50 AM", monday: true)
        late_section = create(:section, start_time: "9:50 AM", end_time: "10:40 AM", monday: true)

        student.sections << early_section
        expect(student.can_enroll_in_section?(late_section)).to be true
      end

      it 'handles sections across noon' do
        morning_section = create(:section, start_time: "11:30 AM", end_time: "12:20 PM", monday: true)
        noon_section = create(:section, start_time: "12:00 PM", end_time: "12:50 PM", monday: true)

        student.sections << morning_section
        expect(student.can_enroll_in_section?(noon_section)).to be false
      end

      it 'handles 80-minute sections across noon' do
        noon_long = create(:section, start_time: "11:40 AM", end_time: "1:00 PM", monday: true)
        conflict_long = create(:section, start_time: "12:00 PM", end_time: "1:20 PM", monday: true)

        student.sections << noon_long
        expect(student.can_enroll_in_section?(conflict_long)).to be false
      end
    end
  end
end
