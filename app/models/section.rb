class Section < ApplicationRecord
  STANDARD_DURATION = [ 50, 80 ].freeze

  belongs_to :teacher
  belongs_to :subject
  belongs_to :classroom
  has_many :student_sections
  has_many :students, through: :student_sections

  validates :start_time, :end_time, presence: true
  validate :valid_time_range
  validate :at_least_one_day_selected
  validate :within_allowed_hours

  scope :for_day, ->(day) { where(day => true) }

  private

  def valid_time_range
    return unless start_time && end_time

    if end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end

    duration = ((end_time - start_time) / 60).to_i
    unless STANDARD_DURATION.include?(duration)
      errors.add(:base, "Section duration must be either 50 or 80 minutes")
    end
  end

  def at_least_one_day_selected
    unless [ monday, tuesday, wednesday, thursday, friday ].any?
      errors.add(:base, "At least one day must be selected")
    end
  end

  def within_allowed_hours
    return unless start_time && end_time

    # Convert start_time and end_time to same-day Time objects for comparison
    current_date = Time.zone.today
    earliest_allowed = Time.zone.parse("7:30", current_date)
    latest_allowed = Time.zone.parse("22:00", current_date)

    section_start = Time.zone.parse(start_time.strftime("%H:%M"), current_date)
    section_end = Time.zone.parse(end_time.strftime("%H:%M"), current_date)

    if section_start < earliest_allowed
      errors.add(:start_time, "cannot be earlier than 7:30 AM")
    end

    if section_end > latest_allowed
      errors.add(:end_time, "cannot be later than 10:00 PM")
    end
  end
end
