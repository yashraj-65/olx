module Api
  module V1
    class BaseController < ActionController::API
     
      before_action :authorize_api_request

      private

      def authorize_api_request
        
        unless request.headers['X-Api-Key'] == 'secret123'
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end
    end
  end
end