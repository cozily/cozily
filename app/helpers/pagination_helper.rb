module PaginationHelper
  def pagination_summary(page, collection)
    return unless collection.present?

    page = page.nil? ? 1 : page.to_i

    per_page = collection.first.class.per_page
    lower = per_page * (page - 1) + 1
    upper = [per_page * page, collection.length].min
    "#{lower}-#{upper} of #{collection.length}"
  end

  def position_in_collection(item, collection)
    collection.index(item) + 1
  end
end