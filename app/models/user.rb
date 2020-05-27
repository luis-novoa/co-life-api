class User < ApplicationRecord
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: {minimum: 2, maximum: 50}
  validates :password, presence: true, length: {minimum: 6, maximum: 50}, on: [:create]
  validates :password_confirmation, presence: true, on: [:create]

  has_many :homes
end
