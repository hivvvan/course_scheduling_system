class Student::SchedulesController < ApplicationController
  def show
    @sections = current_student.sections.includes(:teacher, :subject, :classroom)
  end

  def add_section
    @section = Section.find(params[:section_id])
    @student_section = current_student.student_sections.build(section: @section)

    if @student_section.save
      redirect_to student_schedule_path, notice: 'Section added to schedule.'
    else
      redirect_to sections_path, alert: @student_section.errors.full_messages.join(", ")
    end
  end

  def remove_section
    @student_section = current_student.student_sections.find_by(section_id: params[:section_id])
    @student_section.destroy

    redirect_to student_schedule_path, notice: 'Section removed from schedule.'
  end

  def download_pdf
    @sections = current_student.sections.includes(:teacher, :subject, :classroom)

    respond_to do |format|
      format.pdf do
        pdf = SchedulePdf.new(@sections)
        send_data pdf.render, filename: "schedule.pdf",
                  type: "application/pdf",
                  disposition: "attachment"
      end
    end
  end
end
