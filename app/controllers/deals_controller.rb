class DealsController < ApplicationController
    def index 
    @buyer_profile = current_user.buyer
    @seller_profile = current_user.seller

    b_id = @buyer_profile&.id
    s_id = @seller_profile&.id
        @all_deals = Deal.joins(:conversation)
                     .where("conversations.buyer_id = :b_id OR conversations.seller_id = :s_id",b_id: b_id, s_id: s_id)
        
        @completed_deals = @all_deals.where(buyer_marked_done: true, seller_marked_done: true) 
        @pending_deals = @all_deals.left_outer_joins(:item)
                               .where.not(id: @completed_deals.pluck(:id))
                               .where("items.status != ? OR items.status IS NULL", 2)
    end

    def destroy
    @deal = Deal.find(params[:id])
    @deal.destroy
    
    redirect_to deals_path, notice: "Deal was successfully deleted."
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


    def update
        @deal = Deal.find(params[:id])
        
        puts "DEBUG: Current User ID: #{current_user.id}"
        puts "DEBUG: Seller ID in Deal: #{@deal.conversation.seller_id}"
        puts "DEBUG: Buyer ID in Deal: #{@deal.conversation.buyer_id}"

        if current_user.seller&.id == @deal.conversation.seller_id
            @deal.update(seller_marked_done: true)
            flash[:notice] = "Seller confirmed!"
        elsif current_user.buyer&.id == @deal.conversation.buyer_id
            @deal.update(buyer_marked_done: true)
            flash[:notice] = "Buyer confirmed!"
        else
            flash[:alert] = "You are not authorized to confirm this deal."
    end

    redirect_to deals_path
    end
    private
    def deal_params
        params.require(:deal).permit(:agreed_price)
    end

end
