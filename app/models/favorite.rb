class Favorite < ApplicationRecord
  validates :user_id, presence: true
  validates :home_id, presence: true
  belongs_to :user
end
