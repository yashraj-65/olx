class ConversationsController < ApplicationController

    def create
        buyer=current_user.buyer|| current_user.create_buyer
        buyer_id=buyer.id
        seller_id=params[:seller_id]
        item_id=params[:item_id]
        @conversation = Conversation.where(buyer_id: buyer_id, seller_id: seller_id, item_id: item_id).first_or_create
      

        redirect_to conversation_path(@conversation)
    end
    def index
        @conversations = Conversation.where("buyer_id=? OR seller_id=?",current_user.buyer&.id,current_user.seller&.id).compact
    end
    def show

    @conversation = Conversation.find(params[:id])
    

    @messages = @conversation.messages
    @message = Message.new
  end
end
