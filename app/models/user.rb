class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    has_one :buyer, as: :userable
    has_one :seller, as: :userable
    has_many :messages
    has_many :likes
    has_many :reviews_as_reviewer, through: :buyer, source: :reviews
    has_many :reviews_as_seller, through: :seller, source: :reviews
    has_many :deals_as_buyer, through: :buyer, source: :deals
    has_many :deals_as_seller, through: :seller, source: :deals
    has_many :sold_items, -> {where(deals: {status: :success}).distinct},
    through: :deals_as_seller,
    source: :item
    has_many :bought_items, ->{where(deals: {status: :success}).distinct},
    through: :deals_as_buyer,
    source: :item
    has_one_attached :avatar
     validates :name, presence: true, length: {minimum: 3}
     validates :email, presence: true, uniqueness: true
     PASSWORD_FORMAT = /\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[[:^alnum:]]).{8,}\z/

  validates :password, 
            format: { with: PASSWORD_FORMAT, 
                      message: "must include at least one uppercase letter, one lowercase letter, one number, and one special character" }, 
            allow_nil: true
  after_create :create_default_profiles

    private
   
    def create_default_profiles
        self.create_buyer
        self.create_seller
    end

    def self.ransackable_attributes(auth_object = nil)
      ["id", "name", "email", "role", "created_at"] 
    end
   
    def self.ransackable_associations(auth_object = nil)
      ["seller", "buyer"]
    end

end
