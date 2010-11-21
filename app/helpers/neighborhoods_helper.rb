module NeighborhoodsHelper
  def neighborhood_links(neighborhoods)
    links = []
    neighborhoods.each do |neighborhood|
      links << link_to(neighborhood.name, neighborhood)
    end
    links.to_sentence.html_safe
  end

  def selected_neighborhood_links(neighborhoods)
    spans = []
    neighborhoods.each_with_index do |neighborhood, index|
      span = "<span>"
      span += link_to neighborhood.name, "#", :'data-remove' => 'span'
      span += "<input type='hidden' name='user[profile_attributes][neighborhood_ids][]' value='#{neighborhood.id}' />";
      span += "</span>"
      spans << span
    end
    spans.to_s.html_safe
  end
end