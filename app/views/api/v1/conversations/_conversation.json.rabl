attributes :id, :item_id, :buyer_id, :seller_id, :created_at

child :item do
  attributes :id, :title, :price
end

child :buyer_profile => :buyer_profile do
  attributes :id, :total_spent
  child :userable do
    attributes :name
  end
end

child :seller_profile => :seller_profile do
  attributes :id, :avg_rating
  child :userable do
    attributes :name
  end
end

child :messages => :messages do
  attributes :id, :body, :user_id, :created_at
end