class NeighborhoodsController < ApplicationController
  def index
    @neighborhoods = Neighborhood.all
  end

  def show
    @neighborhood = Neighborhood.find(params[:id])
    @apartments = @neighborhood.listed_apartments
  end

  def search
    render :json => { :apartment_name => render_to_string(:partial => "neighborhoods/name",
                                                          :locals => { :neighborhoods => Neighborhood.for_lat_and_lng(params[:lat], params[:lng]) } )
    }
  end
end
