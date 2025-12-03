class ChatsController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_chat, only: [:show]
  # before_action :profile_exist

  def index
    @chats = current_user.chats.order(created_at: :desc)
  end

  def show
    # redirect_to chats_path, alert: "Not authorized" and return unless @chat.user == current_user
    @chat = Chat.find(params[:id])
    @message = Message.new
    @messages = @chat.messages.order(:created_at)
  end

  def new
    @chat = Chat.new
  end

  def create
    @chat = Chat.new(chat_params)
    @chat.user = current_user
    @chat.user_profile = current_user.user_profile

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

  # Assure qu'un user ne crée pas de chat sans profil fitness
  # def profile_exist
  #   return if current_user.user_profile.present?

  #   redirect_to new_user_profile_path, alert: "Please create your fitness profile first."
  # end

  def chat_params
    params.require(:chat).permit(:title)
  end
end
