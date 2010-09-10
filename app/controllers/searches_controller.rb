class SearchesController < ApplicationController
  def show
    @search = if params[:q].present?
      params[:q][:min_bedrooms] = if(bedrooms = params[:q][:min_bedrooms].scan(/\d+/))
        bedrooms[0]
      else
        nil
      end

      params[:q][:max_rent] = if(rent = params[:q][:max_rent].scan(/\d+/))
        rent[0]
      else
        nil
      end

      Search.new(params[:q].merge(:page => params[:page]))
    else
      Search.new
    end

    respond_to do |format|
      format.html {}
      format.js do
        render :json => { :results => render_to_string(:partial => "searches/results",
                                                       :locals => { :search => @search } ),
                          :map_others => @search.paginated_results.as_json(:methods => :to_param, :include => :address).to_json }
      end
    end
  end
end