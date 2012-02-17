class BuildingsController < ApplicationController
  def show
    @building = Building.find(params[:id])
    @nearby_stations = @building.nearby_stations
    @apartments = Apartment.find(:all, :origin => [@building.lat, @building.lng], :order => 'distance', :limit => 5)
  end
end
