require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  describe "GET /dashboard" do
    context "when user is not signed in" do
      it "displays the public dashboard" do
        get root_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Welcome to University Scheduler")
      end

      it "shows sign up and login links" do
        get root_path
        expect(response.body).to include("Sign Up")
        expect(response.body).to include("Log In")
      end
    end

    context "when student is signed in" do
      let(:student) { create(:student) }
      before { sign_in student }

      it "displays the student dashboard" do
        get root_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include(student.full_name)
      end

      context "with upcoming sections" do
        let!(:section) { create(:section, monday: true, wednesday: true) }
        let!(:enrollment) { create(:student_section, student: student, section: section) }

        it "shows upcoming sections" do
          get root_path
          expect(response.body).to include(section.subject.name)
        end
      end

      context "with available sections" do
        let!(:available_section) { create(:section, monday: true, capacity: 20) }

        it "shows available sections" do
          get sections_path
          expect(response.body).to include(available_section.subject.name)
        end
      end
    end
  end
end
