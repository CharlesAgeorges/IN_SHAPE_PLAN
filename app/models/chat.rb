class Chat < ApplicationRecord
  belongs_to :user_profile
  belongs_to :user
  has_many :messages, dependent: :destroy

  validates :title, presence: true

  SYSTEM_PROMPT = "You're a professional fitness coach with years of experience\n\nI am a coachee of yours, wanting to get in shape\n\ngive me a training plan based on the data i gave you about myself and my goals\n\nau format markup"
end
