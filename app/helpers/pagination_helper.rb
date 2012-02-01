module PaginationHelper
  def pagination_offset(collection)
    (collection.current_page - 1) * collection.limit_value + 1
  end
end
