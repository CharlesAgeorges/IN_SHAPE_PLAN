class UserProfile < ApplicationRecord
  belongs_to :user
  has_many :chats, dependency: :destroy

  validates :goal, :starting_lvl, :equipment, :session_per_week, presence: true
  validates :sessions_per_week, inclusion: { in: 1..7 }, numericality: { only_integer: true }
end
