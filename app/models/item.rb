class Item < ApplicationRecord
    has_one_attached :image
    has_and_belongs_to_many :categories
    belongs_to :seller 
    has_many :deals
    has_many :likes, as: :likeable, dependent: :destroy
    has_many :conversations, dependent: :destroy
    enum status: {pending: 0, available: 1,sold: 2}
    enum condition: {brand_new: 0, small_defect: 1, damaged: 2}
    before_create :set_default_status

    scope :filter_by_category, -> (cat_id) {
      query = where.not(items: { status: :sold })
      if cat_id.present? && cat_id != "All Categories"
        query = query.joins(:categories).where(categories: { id: cat_id })
      end

      query
    }
    scope :search_by_query, -> (query) { where('title ILIKE ? OR items."desc" ILIKE ?', "%#{query}%", "%#{query}%") if query.present? }
    private

    def set_default_status
        self.status||= :available
    end
    def self.ransackable_attributes(auth_object = nil)      
      ["id", "title", "price", "status", "condition", "desc", "warranty", "color", "created_at"]
    end
    def self.ransackable_associations(auth_object = nil)
      ["seller", "deals"]
    end


end
