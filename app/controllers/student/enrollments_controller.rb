class Student::EnrollmentsController < ApplicationController
  before_action :authenticate_student!
  before_action :set_section, only: [ :create ]

  def create
    @enrollment = current_student.student_sections.build(section: @section)

    if @enrollment.save
      redirect_to student_schedule_path, notice: "Successfully enrolled in the section."
    else
      redirect_to sections_path, alert: @enrollment.errors.full_messages.join(", ")
    end
  end

  def destroy
    @enrollment = current_student.student_sections.find(params[:id])
    @enrollment.destroy
    redirect_to student_schedule_path, notice: "Successfully unenrolled from the section."
  end

  private

  def set_section
    @section = Section.find(params[:section_id])
  end
end
