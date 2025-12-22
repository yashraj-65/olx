class SellersController < ApplicationController
  before_action :set_seller_and_user, only: :show

  def show
    @reviews = @seller.reviews.includes(:reviewer)
    @average_rating = @reviews.average(:rating).to_f.round(1)

   @active_listings = @seller.items.where(status: [:available, nil])

    if @user == current_user
      load_sold_and_bought_items
   else
    @sold_items = []
    @bought_items = []
    end
  end

  private

  def set_seller_and_user
    @seller = Seller.find(params[:id])
    @user   = @seller.userable
  end

def load_sold_and_bought_items

  @sold_items = Item
    .joins("INNER JOIN conversations ON conversations.item_id = items.id")
    .joins("INNER JOIN deals ON deals.conversation_id = conversations.id")
    .where(conversations: { seller_id: @seller.id })
    .where(deals: { status: Deal.statuses[:success] })
    .distinct
  if @user.buyer
    @bought_items = Item
      .joins("INNER JOIN conversations ON conversations.item_id = items.id")
      .joins("INNER JOIN deals ON deals.conversation_id = conversations.id")
      .where(conversations: { buyer_id: @user.buyer.id })
      .where(deals: { status: Deal.statuses[:success] })
      .distinct
  else
    @bought_items = []
  end
end

end
