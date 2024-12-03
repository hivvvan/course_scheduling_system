class Section < ApplicationRecord
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
    unless [ 50, 80 ].include?(duration)
      errors.add(:base, "Section duration must be either 50 or 80 minutes")
    end
  end

  def at_least_one_day_selected
    unless %w[ monday, tuesday, wednesday, thursday, friday ].any?
      errors.add(:base, "At least one day must be selected")
    end
  end

  def within_allowed_hours
    earliest_allowed = Time.zone.parse("7:30")
    latest_allowed = Time.zone.parse("22:00")

    if start_time < earliest_allowed
      errors.add(:start_time, "cannot be earlier than 7:30 AM")
    end

    if end_time > latest_allowed
      errors.add(:end_time, "cannot be later than 10:00 PM")
    end
  end
end
