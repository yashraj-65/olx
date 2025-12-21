class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  def current_user
    # 1. If 'user_id' is in the URL, switch to that user
    if params[:user_id].present?
      session[:user_id] = params[:user_id]
    end

    # 2. Find the user based on the session, or default to the first user
    @current_user ||= User.find_by(id: session[:user_id]) || User.first
  end

  helper_method :current_user
end