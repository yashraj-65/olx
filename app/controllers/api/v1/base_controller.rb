require 'pagy'
module Api
  module V1
    class BaseController < ActionController::API
      include Pagy::Backend
      before_action :doorkeeper_authorize!
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  

      private

   
        def current_user
          return nil unless doorkeeper_token
          return nil if doorkeeper_token.resource_owner_id.nil?

          @current_user ||= if doorkeeper_token.respond_to?(:resource_owner_type) && doorkeeper_token.resource_owner_type.present?
            doorkeeper_token.resource_owner_type.constantize.find_by(id: doorkeeper_token.resource_owner_id)
          else
            User.find_by(id: doorkeeper_token.resource_owner_id) || 
            AdminUser.find_by(id: doorkeeper_token.resource_owner_id)
          end
        end

        def record_not_found(exception)
        render json: { 
          error: "Resource not found", 
          message: exception.message 
        }, status: :not_found
      end
      
    end
  end
end