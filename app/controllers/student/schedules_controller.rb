class Student::SchedulesController < ApplicationController
  def show
    @sections = current_student.sections.includes(:teacher, :subject, :classroom)
  end

  def export
    @sections = current_student.sections.includes(:teacher, :subject, :classroom)

    respond_to do |format|
      format.pdf do
        pdf = SchedulePdf.new(@sections)
        send_data pdf.render,
                  filename: "schedule-#{Date.current}.pdf",
                  type: "application/pdf",
                  disposition: "attachment"
      end
    end
  end
end
