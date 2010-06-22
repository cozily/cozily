class YelpController < ApplicationController
  def business_search
    response = JSON.parse(Yelp.new.restaurants_for_lat_and_lng(params[:lat], params[:lng]))
    @businesses = []
    response["businesses"].each do |business|
      @businesses << Business.new(:name => business["name"],
                                  :distance => business["distance"],
                                  :photo_url => business["photo_url"],
                                  :url => business["url"])
    end
    render :json => { :businesses => render_to_string(:partial => "businesses/index",
                                                      :locals => { :businesses => @businesses }) }
  end
end
