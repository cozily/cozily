class BuildingsController < ApplicationController
  def show
    @building = Building.find(params[:id])
    @nearby_stations = @building.nearby_stations
  end
end
