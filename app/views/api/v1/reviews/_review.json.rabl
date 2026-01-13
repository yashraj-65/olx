attributes :id, :content, :rating

child :seller do
    attributes :id, :avg_rating
    child :userable => :user do 
        attributes :name, :email
    end
end

child :deal do
    attributes :id, :status
end