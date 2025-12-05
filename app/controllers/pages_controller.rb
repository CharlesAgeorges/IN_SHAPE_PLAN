class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def profile
    @profile = current_user.user_profile
  end

  def home
  end
end
