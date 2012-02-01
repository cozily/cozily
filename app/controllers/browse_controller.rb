class BrowseController < ApplicationController
  def index
    @all_apartments = Apartment.order("published_at desc").with_state(:published)
    @paginated_apartments = @all_apartments.page(params[:page])
    respond_to do |format|
      format.html
      format.js do
        render :json => {:apartments => render_to_string(:partial => "browse/index"),
                         :map_others => @paginated_apartments.as_json(:methods => :to_param, :include => :address).to_json}
      end
    end
  end
end
