class ItemsController < ApplicationController
    before_action :ensure_owner, only: [:destroy]

    def index
      result = Items::IndexService.new(params).call
      @items = result[:items]
    end

    def new
        @item = Item.new
        @categories = Category.all
    end

    def show
        @item = Item.find(params[:id])
    end

    def create
        result = Items::CreateService.new(current_user, item_params).call
        
        if result[:success]
            redirect_to result[:item], notice: 'Item Created Successfully'
        else
            @item = result[:item]
            @categories = Category.all
            render :new, status: :unprocessable_entity
        end
    end

    def destroy
        result = Items::DestroyService.new(current_user, params[:id]).call
        
        if result[:success]
            redirect_to items_path, notice: "Item was successfully deleted."
        else
            redirect_to items_path, alert: "Failed to delete item."
        end
    end

    def edit
        seller = current_user.seller || current_user.create_seller
        @item = seller.items.find(params[:id])
        @categories = Category.all
    end

    def update
        result = Items::UpdateService.new(current_user, params[:id], item_params).call
        
        if result[:success]
            redirect_to item_path(result[:item])
        else
            @item = result[:item]
            @categories = Category.all
            render :edit, status: :unprocessable_entity
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

