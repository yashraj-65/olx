class Item < ApplicationRecord
    has_one_attached :image
    has_and_belongs_to_many :categories
    belongs_to :seller 
    has_many :deals
    has_many :likes, as: :likeable, dependent: :destroy
    has_many :conversations, dependent: :destroy
    enum :status, { pending: 0, available: 1, sold: 2 }
    enum :condition, { brand_new: 0, small_defect: 1, damaged: 2 }
    validates :title, presence: true
    validates :price, presence: true, numericality: {greater_than: 0}
    validates :desc, presence: true, length: { minimum: 11 }
    validates :address, presence: true, allow_nil: true
    validates :latitude, :longitude, numericality: true, allow_nil: true
    before_create :set_default_status
    before_save :geocode_address, if: :address_changed?

    scope :filter_by_category, -> (cat_id) {
      query = where.not(items: { status: :sold })
      if cat_id.present? && cat_id != "All Categories"
        query = query.joins(:categories).where(categories: { id: cat_id })
      end

      query
    }
    scope :search_by_query, -> (query) { 
      if query.present?
        search_term = "%#{query}%"
        where('items.title ILIKE :q OR items.desc ILIKE :q', q: search_term) 
      end
    }

    def self.ransackable_attributes(auth_object = nil)      
      ["id", "title", "price", "status", "condition", "desc", "warranty", "color", "created_at","latitude","longitude", "address"]
    end
    
    def self.ransackable_associations(auth_object = nil)
      ["seller", "deals","categories"]
    end

    def map_data
      {
        item_id: id,
        latitude: latitude.to_f,
        longitude: longitude.to_f,
        title: title,
        price: price.to_f,
        address: address
      }
    end

    private

    def set_default_status
        self.status||= :available
    end

    def geocode_address
      return if address.blank?
      
      return if latitude.present? && longitude.present?
      
      begin
        Rails.logger.info "Attempting to geocode address: #{address}"
        
        results = Geocoder.search(address)
        
        if results.present?
          result = results.first
          self.latitude = result.latitude
          self.longitude = result.longitude
          Rails.logger.info "Successfully geocoded: #{address} -> #{latitude}, #{longitude}"
        else
          Rails.logger.warn "No geocoding results found for: #{address}"
        end
      rescue Timeout::Error
        Rails.logger.warn "Geocoding timeout for address: #{address}"
      rescue StandardError => e
        Rails.logger.error "Geocoding error for '#{address}': #{e.class} - #{e.message}"
        
      end
    end
end
