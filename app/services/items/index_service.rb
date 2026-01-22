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
      
      {
        items: items.page(@params[:page]).per(per_page),
        query: @params[:query]
      }
    end

    private

    attr_reader :params
  end
end
