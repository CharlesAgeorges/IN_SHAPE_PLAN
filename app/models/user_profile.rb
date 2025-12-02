class UserProfile < ApplicationRecord
  belongs_to :user
  has_many :chats, dependent: :destroy

  validates :goal, :starting_lvl, :equipment, :sessions_per_week, presence: true
  validates :sessions_per_week, numericality: { only_integer: true }, inclusion: { in: 1..7 }
end
