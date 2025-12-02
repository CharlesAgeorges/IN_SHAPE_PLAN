class UserProfilesController < ApplicationController

  before_action :set_user_profile, only: [:edit, :update, :show]

  def new
    @user_profile = UserProfile.new
  end

  def edit
  end

  def create
    @user_profile = UserProfile.new(user_profile_params)
    @user_profile.user = current_user

    if @user_profile.save
      redirect_to @user_profile, notice: "Profil utilisateur créé avec succès. Bienvenue sur InShap_Plan !"
    else
       render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user_profile.update(user_profile_params)
      redirect_to @user_profile, notice: 'Profil utilisateur mis à jour avec succès.'
    else
      render :edit, status: :unprocessable_entity
    end
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
end
