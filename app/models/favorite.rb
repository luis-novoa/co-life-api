class Favorite < ApplicationRecord
  validates :user_id, presence: true
  validates :home_id, presence: true
  validates :user_home, presence: true, uniqueness: true, format: { with: /#{:user_id}_#{:home_id}/ } # format: { with: /\d+_\d+/ }
  belongs_to :user
end
