module Api
  module V1
    class BaseController < ActionController::API
      # This handles the token validation for every API request
      before_action :doorkeeper_authorize!

      private

      # Helper to access the User associated with the token
      def current_user
        @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end
    end
  end
end