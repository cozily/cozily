class BrowseController < ApplicationController
  def index
    @apartments = Apartment.descend_by_published_at.with_state(:published).paginate(:page => params[:page])
    respond_to do |format|
      format.html
      format.js do
        render :json => {:apartments => render_to_string(:layout => "browse/index",
                                                         :locals => {:apartments => @apartments}),
                         :map_others => @apartments.as_json(:methods => :to_param, :include => :address).to_json}
      end
    end
  end
end