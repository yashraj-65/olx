collection @likes
attributes :id, :created_at

child :likeable do
    attributes :id
end

child :buyer do
    attributes :id
    child :userable do
        attributes :name
    end
end

