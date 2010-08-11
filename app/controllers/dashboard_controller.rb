class DashboardController < ApplicationController
  def show
    @events = current_user.timeline_events[0...5]
    if current_user.lister?
      @apartments = current_user.apartments.paginate(:page => params[:page])
      render "listings"
    else
      @matches = Apartment.with_state(:listed).paginate(:page => params[:page])
      render "matches"
    end
  end

  def listings
    render :json => { :listings => render_to_string(:partial => "dashboard/listings",
                                                   :locals => { :apartments => current_user.apartments.paginate(:page => params[:page]) }) }
  end

  def matches
    render :json => { :matches => render_to_string(:partial => "dashboard/matches",
                                                   :locals => { :matches => Apartment.with_state(:listed).paginate(:page => params[:page]) }) }
  end

  def favorites
    render :json => { :favorites => render_to_string(:partial => "dashboard/favorites",
                                                   :locals => { :favorites => current_user.favorite_apartments.paginate(:page => params[:page]) }) }
  end

  def messages
    render :json => { :messages => render_to_string(:partial => "dashboard/messages") }
  end

end