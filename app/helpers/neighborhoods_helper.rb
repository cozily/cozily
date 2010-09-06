module NeighborhoodsHelper
  def neighborhood_links(neighborhoods)
    links = []
    neighborhoods.each do |neighborhood|
      links << link_to(neighborhood.name, neighborhood)
    end
    links.join(", ")
  end
end