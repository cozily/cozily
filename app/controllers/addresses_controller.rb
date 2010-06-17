class AddressesController < ApplicationController
  def geocode
    nyc_bounds = GoogleGeocoder.geocode('New York City').suggested_bounds
    response = GoogleGeocoder.geocode(params[:term], :bias => nyc_bounds)
    results = []
    response.all.each do |result|
      results << { :label => result.full_address,
                   :lat => result.lat,
                   :lng => result.lng }
    end
    render :json => results
  end
end
