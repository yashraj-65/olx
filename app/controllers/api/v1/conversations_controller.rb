module Api
  module V1
    class ConversationsController < BaseController
      before_action :doorkeeper_authorize!

      def index

        user = current_user
        @conversations = Conversation.includes(:item, :messages, buyer_profile: :userable, seller_profile: :userable)
                                     .where(buyer_id: user.buyer&.id)
                                     .or(Conversation.where(seller_id: user.seller&.id))

        render json: @conversations.as_json(
          only: [:id, :item_id, :buyer_id, :seller_id, :created_at],
          include: {
            item: { only: [:id, :title, :price] },


            buyer_profile: {
              only: [:id, :total_spent],
              include: { userable: { only: [:name] } }
            },
            seller_profile: {
              only: [:id, :avg_rating],
              include: { userable: { only: [:name] } }
            },
            messages: {
              only: [:id, :body, :user_id, :created_at]
            }
          }
        )
      end

        def show
        user = current_user
        @conversation= Conversation.find(params[:id])
        render json: @conversation.as_json(
          only: [:id, :item_id, :buyer_id, :seller_id, :created_at],
          include: {
            item: { only: [:id, :title, :price] },

            
            buyer_profile: {
              only: [:id, :total_spent],
              include: { userable: { only: [:name] } }
            },
            seller_profile: {
              only: [:id, :avg_rating],
              include: { userable: { only: [:name] } }
            },
            messages: {
              only: [:id, :body, :user_id, :created_at]
            }
          }
        )
      end




    end
  end
end