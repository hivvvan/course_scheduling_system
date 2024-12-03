class Subject < ApplicationRecord
  has_many :sections

  validates :code, :name, presence: true
  validates :code, uniqueness: true
end
