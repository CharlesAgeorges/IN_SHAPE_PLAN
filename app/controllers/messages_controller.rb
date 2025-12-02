class MessagesController < ApplicationController

  SYSTEM_PROMPT = "You a professional fitness coach with years of experience\n\nI am a coachee of yours, wanting to get in shaoe\n\ngive me a training plan based on the data i gave you about myself and my goals\n\n"

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @user_profile = @chat.user_profile

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      ruby_llm_chat = RubyLLM.chat
      response = ruby_llm_chat.with_instructions(instructions).ask(@message.content)
      Message.create(role: "assistant", content: response.content, chat: @chat)

      redirect_to chat_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
  params.require(:message).permit(:content)
  end

  def instructions
    [SYSTEM_PROMPT, challenge_context].compact.join("\n\n")
  end

  def challenge_context
    "Here is the context of the challenge: #{@challenge.content}."
  end

end
