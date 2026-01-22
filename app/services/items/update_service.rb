module Items
  class UpdateService
    def initialize(user, item_id, item_params)
      @user = user
      @item_id = item_id
      @item_params = item_params
    end

    def call
      seller = @user.seller 
      @item = seller.items.find(@item_id)

      if @item.update(@item_params)
        { success: true, item: @item }
      else
        { success: false, item: @item, errors: @item.errors }
      end
    end

    private

    attr_reader :user, :item_id, :item_params
  end
end
