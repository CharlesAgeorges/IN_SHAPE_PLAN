class ApplicationController < ActionController::Base
  # before_action :authenticate_user!
  # before_action :configure_permitted_parameters
  # check schema et user à check pour vérifier device !!
  allow_browser versions: :modern

 # def configure_permitted_parameters
    # strong params
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])

    # devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])

  # end
end
