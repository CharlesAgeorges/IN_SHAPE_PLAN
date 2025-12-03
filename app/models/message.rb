class Message < ApplicationRecord
  belongs_to :chat
  validates :role, :content, presence: true


    private

  # def user_message limit
end
