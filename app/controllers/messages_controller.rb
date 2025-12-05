class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @message = @chat.messages.new(message_params)
    @message.role = "user"
    # @message.chat = @chat

    if @message.save
      @assistant_message = @chat.messages.create(role: "assistant", content: "")
      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history
      @ruby_llm_chat.with_instructions(instructions)
      @response = @ruby_llm_chat.ask(@message.content) do |chunk|
        next if chunk.content.blank? # skip empty chunks

        @assistant_message.content += chunk.content
        broadcast_replace(@assistant_message)
      end
      # @chat.messages.create(role: "assistant", content: response.content)

      @assistant_message.update(content: @response.content)
      broadcast_replace(@assistant_message)

      respond_to do |f|
        f.turbo_stream
        f.html { redirect_to chat_path(@chat) }
      end
    else
       respond_to do |f|
        f.turbo_stream { render turbo_stream: turbo_stream.replace("new_message_container", partial: "messages/form", locals: { chat: @chat, message: @message }) }
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
      next if message.content.blank?

      @ruby_llm_chat.add_message(message)
    end
  end

  def broadcast_replace(message)
    Turbo::StreamsChannel.broadcast_replace_to(@chat, target: helpers.dom_id(message), partial: "messages/message", locals: { message: message })
    Turbo::StreamsChannel.broadcast_remove_to(@chat, target: "new_message")
    Turbo::StreamsChannel.broadcast_replace_to(@chat, target: "new_message_container", partial: "messages/form", locals: { message: Message.new, chat: @chat })
  end
end
