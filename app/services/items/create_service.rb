module Items
  class CreateService
    def initialize(user, item_params)
      @user = user
      @item_params = item_params
    end

    def call
      seller = @user.seller || @user.create_seller
      @item = seller.items.build(@item_params)
      
      if @item.save
        { success: true, item: @item }
      else
        { success: false, item: @item, errors: @item.errors }
      end
    end

    private

    attr_reader :user, :item_params
  end
end
