class ItemsController < ApplicationController
    before_action :ensure_owner, only: [:destroy]
    def index
        @items = Item.all.order(created_at: :desc)
    end
    def new
        @item = Item.new
        @categories = Category.all
    end
    def show
        @item = Item.find(params[:id])
    end
    def create
        seller = current_user.seller||current_user.create_seller
        @item = seller.items.build(item_params)

        if @item.save
            redirect_to @item, notice: 'Item Created Successfully'
        else
            @categories = Category.all
            render :new
        end
        end
    def destroy
        seller = current_user.seller || current_user.create_seller
        @item = seller.items.find(params[:id])
        if @item.destroy
            redirect_to items_path, notice: "Item was successfully deleted."
        else
            redirect_to items_path, alert: "Failed to delete item."
        end
    end
private
        def item_params
            params.require(:item).permit(:title, :desc, :status, :warranty, :color, :price, :condition, :is_negotiable, :image, category_ids: [])
        end
        def ensure_owner
            @item = Item.find(params[:id])
            unless current_user.seller == @item.seller
                 redirect_to items_path, alert: "You are not authorized to delete this item."
            end
        end

        
end

