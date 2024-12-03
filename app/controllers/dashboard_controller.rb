class DashboardController < ApplicationController
  skip_before_action :authenticate_student!, only: [ :index ]

  def index
    if student_signed_in?
      @upcoming_sections = current_student.sections
                                          .includes(:teacher, :subject, :classroom)
                                          .where("start_time >= ?", Time.current)
                                          .order(start_time: :asc)
                                          .limit(5)

      @available_sections = Section.includes(:teacher, :subject, :classroom)
                                   .where("capacity > (SELECT COUNT(*) FROM student_sections WHERE section_id = sections.id)")
                                   .order(created_at: :desc)
                                   .limit(5)
    else
      @total_courses = Subject.count
      @total_teachers = Teacher.count
      @featured_subjects = Subject.order(created_at: :desc).limit(3)
    end
  end
end
