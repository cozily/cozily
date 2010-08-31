class SearchesController < ApplicationController
  def show
    @search = params[:q].present? ? Search.new(params[:q].merge(:page => params[:page])) : Search.new
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