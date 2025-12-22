class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  def current_user
   
    if params[:user_id].present?
      session[:user_id] = params[:user_id]
    end

    @current_user ||= User.find_by(id: session[:user_id]) || User.first
  end

  helper_method :current_user
end