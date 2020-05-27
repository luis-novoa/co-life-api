class Home < ApplicationRecord
  validates :title, presence: true, length: {minimum: 3, maximum: 100}
  validates :address, presence: true, uniqueness: { case_sensitive: false }, length: {minimum: 3, maximum: 100}
  validates :city, presence: true, length: {minimum: 3, maximum: 50}
  validates :country, presence: true, length: {minimum: 3, maximum: 60}
  validates :rent, presence: true, numericality: true
  validates :room_type, presence: true, inclusion: { in: %w(individual shared) }
  validates :more_info, length: {minimum: 0, maximum: 500}, allow_nil: true
  validates :user_id, presence: true
  belongs_to :user
end
