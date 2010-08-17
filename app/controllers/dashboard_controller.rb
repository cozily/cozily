class DashboardController < ApplicationController
  before_filter :load_events

  def show
    if current_user.lister?
      @apartments = current_user.apartments.paginate(:page => params[:page])
      render "listings"
    else
      @matches = Apartment.with_state(:listed).paginate(:page => params[:page])
      render "matches"
    end
  end

  def listings
    @apartments = current_user.apartments.paginate(:page => params[:page])
    respond_to do |format|
      format.html
      format.js do
        render :json => { :listings => render_to_string(:layout => "dashboard/listings",
                                                        :locals => { :apartments => current_user.apartments.paginate(:page => params[:page]) }) }
      end
    end
  end

  def matches
    @matches = Apartment.with_state(:listed).paginate(:page => params[:page])
    respond_to do |format|
      format.html
      format.js do
        render :json => { :matches => render_to_string(:layout => "dashboard/matches",
                                                       :locals => { :matches => @matches }) }
      end
    end
  end

  def favorites
    @favorites = current_user.favorite_apartments.paginate(:page => params[:page])
    respond_to do |format|
      format.html
      format.js do
        render :json => { :favorites => render_to_string(:layout => "dashboard/favorites",
                                                         :locals => { :favorites => @favorites }) }
      end
    end
  end

  def messages
    page, per_page = params[:page] || 1, params[:per_page] || 1
    @messages = Message.for_user(current_user).root.paginate(:page => page, :per_page => per_page)
    respond_to do |format|
      format.html
      format.js do
        render :json => { :messages => render_to_string(:layout => "dashboard/messages",
                                                        :locals => { :messages => @messages }) }
      end
    end
  end

  private
  def load_events
    @events = current_user.timeline_events[0...5]
  end
end