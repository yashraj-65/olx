attributes  :id, :name, :email

child :seller do
    attributes :id, :avg_rating

    child :items do
    attributes :id, :title, :price, :status
    end
end

child :buyer do
  attributes :id, :purchase_count, :total_spent
end
