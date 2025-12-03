class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @message = @chat.messages.new(message_params)
    @message.role = "user"
    # @message.chat = @chat

    if @message.save
      ruby_llm_chat = RubyLLM.chat
      response = ruby_llm_chat.with_instructions(instructions).ask(@message.content)
      @chat.messages.create(role: "assistant", content: response.content)
      # @chat.messages.create
      redirect_to chat_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  # @chat.message.each do mesaage
  # ruby_llm_chat.add.message(message)
  # end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def instructions
    Chat::SYSTEM_PROMPT
  end
end
