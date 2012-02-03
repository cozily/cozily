class NeighborhoodsController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.js do
        render :json => {:borough => render_to_string(:partial => "neighborhoods/borough",
                                                      :locals  => {:neighborhoods => Neighborhood.where(:borough => params[:borough])})
        }
      end
    end
  end

  def show
    @neighborhood = Neighborhood.find(params[:id])
    @apartments = @neighborhood.published_apartments.page(params[:page])

    respond_to do |format|
      format.html {}
      format.js do
        render :json => { :apartments => render_to_string(:partial => "neighborhoods/apartments",
                                                          :locals => { :apartments => @apartments } ),
                          :map_others => @apartments.as_json(:methods => :to_param, :include => :building).to_json }
      end
    end
  end

  def search
    render :json => { :apartment_name => render_to_string(:partial => "apartments/neighborhood",
                                                          :locals => { :neighborhoods => Neighborhood.for_lat_and_lng(params[:lat], params[:lng]) } )
    }
  end
end
