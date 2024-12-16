class Student < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :student_sections
  has_many :sections, through: :student_sections

  validates :first_name, :last_name, :email, :student_id, presence: true
  validates :email, :student_id, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  def full_name
    "#{first_name} #{last_name}"
  end

  def can_enroll_in_section?(section)
    return false if sections.include?(section)

    sections.each do |enrolled_section|
      return false if sections_overlap?(enrolled_section, section)
    end

    true
  end

  private

  def sections_overlap?(section1, section2)
    return false unless share_any_days?(section1, section2)

    !(section1.end_time <= section2.start_time || section2.end_time <= section1.start_time)
  end

  def share_any_days?(section1, section2)
    %w[monday tuesday wednesday thursday friday].any? do |day|
      section1.public_send(day) && section2.public_send(day)
    end
  end
end
