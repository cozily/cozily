module NeighborhoodsHelper
  def neighborhood_links(apartment)
    links = []
    apartment.neighborhoods.each do |neighborhood|
      links << link_to(neighborhood.name, neighborhood)
    end
    links.join(", ")
  end
end