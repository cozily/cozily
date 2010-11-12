class SearchesController < ApplicationController
  def show
    if params[:q].present?
      session[:neighborhood_ids] = params[:q][:neighborhood_ids]

      session[:min_bedrooms] = if (bedrooms = params[:q][:min_bedrooms].scan(/\d+/))
        bedrooms[0]
      else
        nil
      end

      session[:max_rent] = if (rent = params[:q][:max_rent].scan(/\d+/))
        rent[0]
      else
        nil
      end
    end

    load_search

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