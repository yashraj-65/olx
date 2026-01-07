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
  allowed_conversations = Conversation.where("buyer_id = ? OR seller_id = ?", current_user.id, current_user.id)
  @conversation = allowed_conversations.find(params[:id])
  @conversations = allowed_conversations
  @messages = @conversation.messages.includes(:user)
  @message = Message.new

    rescue ActiveRecord::RecordNotFound
    redirect_to conversations_path, alert: "You do not have access to that conversation."
   end
    
    end
