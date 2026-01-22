module Items
  class DestroyService
    def initialize(user, item_id)
      @user = user
      @item_id = item_id
    end

    def call
      seller = @user.seller 
      @item = seller.items.find(@item_id)

      if @item.destroy
        { success: true, item: @item }
      else
        { success: false, item: @item, errors: @item.errors }
      end
    end

    private

    attr_reader :user, :item_id
  end
end
