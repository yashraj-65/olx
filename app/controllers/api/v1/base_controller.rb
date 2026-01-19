module Api
  module V1
    class BaseController < ActionController::API
      before_action :doorkeeper_authorize!

      private

        def current_user
          return nil unless doorkeeper_token

          @current_user ||= if doorkeeper_token.respond_to?(:resource_owner_type) && doorkeeper_token.resource_owner_type.present?
            doorkeeper_token.resource_owner_type.constantize.find_by(id: doorkeeper_token.resource_owner_id)
          else
            # FIX: Try User first. Only if no User exists with that ID, check AdminUser.
            User.find_by(id: doorkeeper_token.resource_owner_id) || 
            AdminUser.find_by(id: doorkeeper_token.resource_owner_id)
          end
        end
    end
  end
end