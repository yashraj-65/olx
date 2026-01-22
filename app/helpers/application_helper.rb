module ApplicationHelper
  include Pagy::Frontend
  def pagy_metadata(pagy)
    {
      count: pagy.count,
      pages: pagy.pages,
      current_page: pagy.page,
      next_page: pagy.next,
      prev_page: pagy.prev,
      items_per_page: pagy.items,
    }
  end
end
