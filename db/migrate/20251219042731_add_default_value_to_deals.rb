class AddDefaultValueToDeals < ActiveRecord::Migration[7.2]
  def change
    change_column_default :deals, :buyer_marked_done, from:nil, to: false
        change_column_default :deals, :seller_marked_done, from:nil, to: false
  end
end
