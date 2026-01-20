module Api
  module V1
    class MessagesController < BaseController
      before_action :doorkeeper_authorize!
      before_action :set_conversation
    
      def index
        @messages = @conversation.messages.includes(:user)
      end
      def show
        @message = @conversation.messages.find(params[:id])
      end
      def create
        @message = @conversation.messages.new(message_params)
        @message.user = current_user

        if @message.save
          render :show, status: :created
        else
          render json: { message: "failed to send", errors: @message.errors }, status: :unprocessable_entity
        end
      end

      private

        def set_conversation
            @conversation = Conversation
                .where(buyer_id: current_user.buyer&.id)
                .or(Conversation.where(seller_id: current_user.seller&.id))
                .find(params[:conversation_id])

        end


      def message_params
        params.require(:message).permit(:body)
      end
    end
  end
end