require 'rails_helper'

RSpec.describe Teacher, type: :model do
  describe 'validations' do
    let!(:teacher) { FactoryBot.create(:teacher) }

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end

  describe 'associations' do
    it { should have_many(:sections) }
  end

  describe '#full_name' do
    it 'returns the full name of the teacher' do
      teacher = create(:teacher, first_name: 'John', last_name: 'Doe')
      expect(teacher.full_name).to eq('John Doe')
    end
  end
end
