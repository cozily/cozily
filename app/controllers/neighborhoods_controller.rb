class NeighborhoodsController < ApplicationController
  before_filter :authenticate

  def show
    @neighborhood = Neighborhood.find(params[:id])
    @apartments = @neighborhood.published_apartments.paginate(:page => params[:page], :per_page => Apartment.per_page)

    respond_to do |format|
      format.html {}
      format.js do
        render :json => { :apartments => render_to_string(:partial => "neighborhoods/apartments",
                                                          :locals => { :apartments => @apartments } ),
                          :map_others => @apartments.as_json(:methods => :to_param, :include => :address).to_json }
      end
    end
  end

  def search
    render :json => { :apartment_name => render_to_string(:partial => "apartments/neighborhood",
                                                          :locals => { :neighborhoods => Neighborhood.for_lat_and_lng(params[:lat], params[:lng]) } )
    }
  end
end
