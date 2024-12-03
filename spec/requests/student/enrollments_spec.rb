require 'rails_helper'

RSpec.describe "Student::Enrollments", type: :request do
  let(:student) { create(:student) }
  let(:section) { create(:section) }

  before do
    sign_in student
  end

  describe "POST /student/enrollments" do
    context "when student is not enrolled in any sections" do
      it "creates a new enrollment" do
        expect {
          post student_enrollments_path, params: { section_id: section.id }
        }.to change(StudentSection, :count).by(1)

        expect(response).to redirect_to(student_schedule_path)
        expect(flash[:notice]).to eq('Successfully enrolled in the section.')
      end
    end

    context "when section has time conflict" do
      let!(:existing_section) do
        create(:section,
               start_time: "08:00",
               end_time: "08:50",
               monday: true,
               wednesday: true,
               friday: true
        )
      end

      let!(:existing_enrollment) do
        create(:student_section, student: student, section: existing_section)
      end

      let(:conflicting_section) do
        create(:section,
               start_time: "08:00",
               end_time: "08:50",
               monday: true
        )
      end

      it "does not create enrollment and shows error message" do
        expect {
          post student_enrollments_path, params: { section_id: conflicting_section.id }
        }.not_to change(StudentSection, :count)

        expect(response).to redirect_to(sections_path)
        expect(flash[:alert]).to include("Schedule conflict")
      end
    end

    context "when section is at capacity" do
      let(:full_section) do
        create(:section, capacity: 1)
      end

      before do
        # Fill the section with another student
        create(:student_section, section: full_section, student: create(:student))
      end

      it "does not create enrollment and shows error message" do
        expect {
          post student_enrollments_path, params: { section_id: full_section.id }
        }.not_to change(StudentSection, :count)

        expect(response).to redirect_to(sections_path)
        expect(flash[:alert]).to include("Section is at capacity")
      end
    end
  end

  describe "DELETE /student/enrollments/:id" do
    let!(:enrollment) { create(:student_section, student: student, section: section) }

    it "removes the enrollment" do
      expect {
        delete student_enrollment_path(enrollment)
      }.to change(StudentSection, :count).by(-1)

      expect(response).to redirect_to(student_schedule_path)
      expect(flash[:notice]).to eq('Successfully unenrolled from the section.')
    end

    context "when trying to delete another student's enrollment" do
      let(:other_student) { create(:student) }
      let!(:other_enrollment) { create(:student_section, student: other_student, section: section) }

      it "raises ActiveRecord::RecordNotFound" do
        expect {
          delete student_enrollment_path(other_enrollment)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
