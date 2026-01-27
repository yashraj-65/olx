module Items
  class IndexService
    def initialize(params)
      
      @params = params
    end

    def call
      items = Item.filter_by_category(@params[:category])
      
      if @params[:query].present?
        items = items.search_by_query(@params[:query])
      end

      items = items.with_attached_image.includes(seller: :userable)
      per_page = @params[:query].present? ? 4 : 6
      
      paginated_items = items.page(@params[:page]).per(per_page)
      
      # Build map data from items with valid coordinates
      map_data = paginated_items
                  .select { |item| item.latitude.present? && item.longitude.present? }
                  .map { |item| item.map_data }
      
      {
        items: paginated_items,
        query: @params[:query],
        map_data: map_data
      }
    end

    private

    attr_reader :params
  end
end
