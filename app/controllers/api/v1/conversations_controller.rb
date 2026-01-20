module Api
  module V1
    class ConversationsController < BaseController
      before_action :doorkeeper_authorize!

      def index
        user = current_user
        @conversations = Conversation.includes(:item, :messages, buyer_profile: :userable, seller_profile: :userable)
                                     .where(buyer_id: user.buyer&.id)
                                     .or(Conversation.where(seller_id: user.seller&.id))
      end
      def show
        user = current_user
        @conversation= Conversation.find(params[:id])
      end
    end
  end
end