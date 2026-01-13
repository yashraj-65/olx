attributes :id, :agreed_price, :status, :seller_marked_done, :buyer_marked_done

child :buyer do
  attributes :id
  child :userable do
    attributes :name
  end
end


child :seller do
  attributes :id
  child :userable do
    attributes :name
  end
end

child :item do
  attributes :title, :desc, :price
end