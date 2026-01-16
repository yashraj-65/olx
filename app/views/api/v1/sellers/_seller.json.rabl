attributes :id, :avg_rating, :contact_number, :created_at


child :userable => :user do
  attributes :id, :name, :email
  

end