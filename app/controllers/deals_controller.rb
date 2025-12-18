class DealsController < ApplicationController
    def index 
        buyer_id=current_user.buyer&.id
        seller_id=current_user.seller&.id

        @all_deals = Deal.joins(:conversation)
                     .where("conversations.buyer_id = ? OR conversations.seller_id = ?", buyer_id, seller_id)
        @pending_deals = @all_deals.where.not(buyer_marked_done: true, seller_marked_done: true)
        @completed_deals = @all_deals.where(buyer_marked_done: true, seller_marked_done: true) 
    end
    def create
        @conversation = Conversation.find(params[:conversation_id])
        @item = @conversation.item
        @deal=@item.deals.build(deal_params)
        @deal.conversation=@conversation
        @deal.proposer = current_user
        @deal.status = :success

        if current_user.buyer == @conversation.buyer_profile
            @deal.buyer_marked_done = true
        else
            @deal.seller_marked_done = true
        end
        if @deal.save
            redirect_to @conversation, notice: "Deal has been proposed!"
        else
            redirect_to @conversation, alert: "deal failed"
        end
    end
    def updated
        @deal = Deal.find(params[:id])
         if current_user.seller==@deal.seller
            @deal.update(seller_marked_done: true)
         elsif current_user.buyer==@deal.buyer
            @deal.update(buyer_marked_done: true)
         end
         redirect_to @deal.conversation
    end

    private
    def deal_params
        params.require(:deal).permit(:agreed_price)
    end

end
