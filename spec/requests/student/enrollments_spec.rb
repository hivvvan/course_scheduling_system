require 'rails_helper'

RSpec.describe "Student::Enrollments", type: :request do
  before(:all) do
    Devise.mappings[:student] = Devise.add_mapping(:student, {})
  end

  let(:student) { create(:student) }
  let(:section) { create(:section, monday: true) }

  before do
    sign_in student
  end

  describe "POST /student/enrollments" do
    context "when student is not enrolled in any sections" do
      it "creates a new enrollment" do
        expect {
          post student_enrollments_path, params: { section_id: section.id }
        }.to change { student.sections.count }.by(1)

        expect(response).to redirect_to(student_schedule_path)
        expect(flash[:notice]).to eq('Successfully enrolled in the section.')
      end
    end

    context "when section has time conflict" do
      let(:conflicting_section) do
        create(:section,
               start_time: "08:00",
               end_time: "08:50",
               monday: true
        )
      end

      before do
        existing_section = create(:section,
                                  start_time: "08:00",
                                  end_time: "08:50",
                                  monday: true,
                                  wednesday: true,
                                  friday: true)

        create(:student_section, student: student, section: existing_section)
      end

      it "does not create enrollment and shows error message" do
        expect {
          post student_enrollments_path, params: { section_id: conflicting_section.id }
        }.not_to change { student.reload.sections.count }

        expect(response).to redirect_to(sections_path)
        expect(flash[:alert]).to include("Schedule conflict")
      end
    end

    context "when section is at capacity" do
      let(:full_section) do
        create(:section, monday: true, capacity: 1)
      end

      before do
        # Fill the section with another student
        create(:student_section, section: full_section, student: create(:student))
      end

      it "does not create enrollment and shows error message" do
        expect {
          post student_enrollments_path, params: { section_id: full_section.id }
        }.not_to change { student.sections.count }

        expect(response).to redirect_to(sections_path)
        expect(flash[:alert]).to include("Section is at capacity")
      end
    end
  end

  describe "DELETE /student/enrollments/:id" do
    let(:enrollment) { create(:student_section, student: student, section: section) }

    before do
      enrollment
    end

    it "removes the enrollment" do
      expect {
        delete student_enrollment_path(enrollment)
      }.to change { student.sections.count }.by(-1)

      expect(response).to redirect_to(student_schedule_path)
      expect(flash[:notice]).to eq('Successfully unenrolled from the section.')
    end

    context "when trying to delete another student's enrollment" do
      let(:other_student) { create(:student) }
      let(:other_enrollment) { create(:student_section, student: other_student, section: section) }

      before do
        other_enrollment
      end

      it "returns 404 not found status" do
        delete student_enrollment_path(other_enrollment)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
