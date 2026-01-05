class ApplicationController < ActionController::Base
  before_action :authenticate_user! , unless: :admin_request?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :description, :avatar])
  end

  def admin_request?
  # This checks if the request is for an ActiveAdmin page or an AdminUser devise action
    request.path.start_with?('/admin')
end

  allow_browser versions: :modern

end