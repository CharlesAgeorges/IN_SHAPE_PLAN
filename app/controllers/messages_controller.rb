class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @message = @chat.messages.new(message_params)
    @message.role = "user"
    # @message.chat = @chat

    if @message.save
      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history
      response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)
      @chat.messages.create(role: "assistant", content: response.content)
      respond_to do |f|
        f.turbo_stream
        f.html { redirect_to chat_path(@chat) }
      end
    else
       respond_to do |f|
        f.turbo_stream { render turbo_stream: turbo_stream.replace("new_message", partial: "messages/form", locals: { chat: @chat, message: @message }) }
        f.html { render "chats/show", status: :unprocessable_entity }
       end
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

  def build_conversation_history
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end
end
