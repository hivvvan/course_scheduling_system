require 'rails_helper'

RSpec.describe Student::SchedulesController, type: :request do
  let(:student) { create(:student) }
  let(:section) { create(:section) }

  before do
    sign_in student
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get student_schedule_path
      expect(response).to be_successful
    end
  end

  describe 'POST #add_section' do
    context 'with valid section' do
      it 'adds section to student schedule' do
        expect {
          post student_schedule_add_section_path(section_id: section.id)
        }.to change(student.sections, :count).by(1)
      end
    end

    context 'with schedule conflict' do
      let(:conflicting_section) { create(:section, start_time: section.start_time,
                                         end_time: section.end_time, monday: true) }

      before do
        student.sections << section
      end

      it 'does not add conflicting section' do
        expect {
          post student_schedule_add_section_path(section_id: conflicting_section.id)
        }.not_to change(student.sections, :count)
      end
    end
  end

  describe 'DELETE #remove_section' do
    before do
      student.sections << section
    end

    it 'removes section from student schedule' do
      expect {
        delete student_schedule_remove_section_path(section_id: section.id)
      }.to change(student.sections, :count).by(-1)
    end
  end

  describe 'GET #download_pdf' do
    it 'returns a PDF file' do
      get student_schedule_download_pdf_path(format: :pdf)
      expect(response.content_type).to eq('application/pdf')
      expect(response.headers['Content-Disposition']).to include('attachment')
    end
  end
end
