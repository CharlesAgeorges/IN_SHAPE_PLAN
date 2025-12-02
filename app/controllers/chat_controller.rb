class ChatsController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_chat, only: [:show]

  def index
    @chats = current_user.chats.order(created_at: :desc)
  end

  def show
    @message = Message.new
    @messages = @chat.messages.order(:created_at)
  end

  def new
    @chat = Chat.new
    @profiles = current_user.user_profile
  end

  def create
    @chat = Chat.new(chat_params)
    @chat.user = current_user

    if @chat.save
      redirect_to @chat, notice: "Chat created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def chat_params
    params.require(:chat).permit(:title, :user_profile_id)
  end
end
