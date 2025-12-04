class UserProfile < ApplicationRecord
  belongs_to :user
  has_many :chats, dependent: :destroy

  validates :goal, :starting_lvl, :equipment, :sessions_per_week, presence: true
  validates :sessions_per_week, numericality: { only_integer: true }, inclusion: { in: 1..7 }

  def training_title
    level    = starting_lvl.presence || "Niveau inconnu"
    sessions = sessions_per_week.presence || "?"
    objectif = goal.presence || "Non défini"

    "#{level} · #{sessions} séances / semaine · Objectif : #{objectif}"
  end
end
