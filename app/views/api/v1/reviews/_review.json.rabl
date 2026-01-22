attributes :id, :content

child :reviewer => :reviewer do
  child :userable => :user do
    attributes :id, :name
  end
end
child :seller do
    attributes :id, :avg_rating
    child :userable => :user do 
        attributes :name, :email
    end
end


child :deal do
    attributes :id, :status
end