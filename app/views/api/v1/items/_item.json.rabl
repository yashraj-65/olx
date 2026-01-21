attributes :id, :title, :desc, :price, :status

    child :seller do
        attributes :id, :avg_rating

        child :userable do
        attributes :name, :email
        end
    end
