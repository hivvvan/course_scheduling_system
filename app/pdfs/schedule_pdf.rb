class SchedulePdf < Prawn::Document
  def initialize(sections)
    super()
    @sections = sections
    generate_schedule
  end

  def generate_schedule
    text "Class Schedule", size: 24, style: :bold
    move_down 20

    @sections.each do |section|
      text "#{section.subject.name}", size: 14, style: :bold
      text "Teacher: #{section.teacher.full_name}"
      text "Time: #{format_time(section.start_time)} - #{format_time(section.end_time)}"
      text "Days: #{format_days(section)}"
      text "Location: #{section.classroom.full_name}"
      move_down 15
    end
  end

  private

  def format_time(time)
    time.strftime("%I:%M %p")
  end

  def format_days(section)
    days = []
    days << "Mon" if section.monday
    days << "Tue" if section.tuesday
    days << "Wed" if section.wednesday
    days << "Thu" if section.thursday
    days << "Fri" if section.friday
    days.join(", ")
  end
end
