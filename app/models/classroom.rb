class Classroom < ApplicationRecord
  has_many :sections

  validates :building, :room_number, presence: true
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :room_number, uniqueness: { scope: :building }

  def full_name
    "#{building} #{room_number}"
  end
end
