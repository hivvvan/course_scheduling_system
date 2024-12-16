class StudentSection < ApplicationRecord
  belongs_to :student
  belongs_to :section

  validates :student_id, uniqueness: { scope: :section_id }
  validate :no_schedule_conflicts
  validate :section_has_capacity

  private

  def no_schedule_conflicts
    unless student.can_enroll_in_section?(section)
      errors.add(:base, "Schedule conflict with existing section")
    end
  end

  def section_has_capacity
    if section.capacity && section.students.count >= section.capacity
      errors.add(:base, "Section is at capacity")
    end
  end
end
