require 'rails_helper'

RSpec.describe "Student::Schedules", type: :request do
  let(:student) { create(:student) }

  before do
    sign_in student
  end

  describe "GET /student/schedule" do
    let!(:section1) { create(:section, start_time: "09:00", end_time: "09:50") }
    let!(:section2) { create(:section, start_time: "10:00", end_time: "10:50") }

    before do
      create(:student_section, student: student, section: section1)
      create(:student_section, student: student, section: section2)
    end

    it "displays the student's schedule" do
      get student_schedule_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include(section1.subject.name)
      expect(response.body).to include(section2.subject.name)
    end
  end

  describe "GET /student/schedule/export" do
    let!(:section) { create(:section) }

    before do
      create(:student_section, student: student, section: section)
    end

    it "generates a PDF schedule" do
      get export_student_schedule_path(format: :pdf)

      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/pdf')
      expect(response.headers['Content-Disposition']).to include('attachment')
      expect(response.headers['Content-Disposition']).to include('.pdf')
    end
  end
end
