class UserProfilesController < ApplicationController
  before_action :set_user_profile, only: %i[edit update show destroy]

  def new
    @user_profile = UserProfile.new
  end

  def edit
  end

  def create
    @user_profile = UserProfile.new(user_profile_params)
    @user_profile.user = current_user
    if @user_profile.save
      @chat = Chat.create!(user_id: current_user.id, user_profile_id: @user_profile.id,
                           title: "Ton plan d'entraînement")
      ruby_llm_chat = RubyLLM.chat
      response = ruby_llm_chat.with_instructions(user_profile_characteristics).ask("Fais moi un training plan par rapport aux instructions")
      Message.create!(chat: @chat, role: "assistant", content: response.content)
      redirect_to chat_path(@chat)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user_profile.update(user_profile_params)
      redirect_to chat_path(@user_profile.chat), notice: "Profil utilisateur mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user_profile.destroy
    redirect_to chat_path(@user_profile.chat), notice: "Entraînement supprimé."
  end

  def show
  end

  private

  def set_user_profile
    @user_profile = UserProfile.find(params[:id])
  end

  def user_profile_params
    params.require(:user_profile).permit(:goal, :starting_lvl, :equipment, :sessions_per_week)
  end

  def sessions_per_week
    "voici mes dispos par semaine : #{@user_profile.sessions_per_week}"
  end

  def user_profile_characteristics
    [Chat::SYSTEM_PROMPT, @user_profile.goal, @user_profile.starting_lvl, @user_profile.equipment,
     sessions_per_week].compact.join("\n\n")
  end
end
