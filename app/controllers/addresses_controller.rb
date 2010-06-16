class AddressesController < ApplicationController
  def geocode
    response = GoogleGeocoder.geocode(params[:term])
    results = []
    response.all.each do |result|
      results << { :label => result.full_address,
                   :lat => result.lat,
                   :lng => result.lng }
    end
    render :json => results
  end
end