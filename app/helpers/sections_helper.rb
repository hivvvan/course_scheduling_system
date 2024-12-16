module SectionsHelper
  def format_section_days(section)
    days = []
    days << "M" if section.monday
    days << "T" if section.tuesday
    days << "W" if section.wednesday
    days << "Th" if section.thursday
    days << "F" if section.friday
    days.join(" / ")
  end
end
