class Favorite < ApplicationRecord
  before_validation :ensure_user_home_format

  validates :user_id, presence: true
  validates :home_id, presence: true
  validates :user_home, presence: true, uniqueness: true, format: { with: /\d+_\d+/ }
  belongs_to :user
  belongs_to :home

  private

  def ensure_user_home_format
    errors.add(:user_home, 'Invalid ids or wrong id order.') unless user_home == "#{user_id}_#{home_id}"
  end
end
