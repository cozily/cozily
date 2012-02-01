class DashboardController < ApplicationController
  before_filter :authenticate_user!, :except => [ :fail, :map ]
  before_filter :load_events

  def show
    flash.keep
    if current_user.lister?
      redirect_to :action => :listings
    else
      redirect_to :action => :matches
    end
  end

  def listings
    @apartments = current_user.apartments.page(params[:page])
    respond_to do |format|
      format.html
      format.js do
        render :json => {:listings   => render_to_string(:partial => "dashboard/listings",
                                                         :locals  => {:apartments => @apartments}),
                         :tabs       => render_to_string(:partial => "dashboard/tabs",
                                                         :locals  => {:active => :listings}),
                         :map_others => @apartments.as_json(:methods => :to_param, :include => :address).to_json}
      end
    end
  end

  def matches
    @matches = current_user.matches(params[:page] || 1).results
    respond_to do |format|
      format.html
      format.js do
        render :json => {:matches    => render_to_string(:partial => "dashboard/matches",
                                                         :locals  => {:matches => @matches}),
                         :tabs       => render_to_string(:partial => "dashboard/tabs",
                                                         :locals  => {:active => :matches}),
                         :map_others => @matches.as_json(:methods => :to_param, :include => :address).to_json}
      end
    end
  end

  def favorites
    @favorites = current_user.favorite_apartments.page(params[:page])
    respond_to do |format|
      format.html
      format.js do
        render :json => {:favorites  => render_to_string(:partial => "dashboard/favorites",
                                                         :locals  => {:favorites => @favorites}),
                         :tabs       => render_to_string(:partial => "dashboard/tabs",
                                                         :locals  => {:active => :favorites}),
                         :map_others => @favorites.as_json(:methods => :to_param, :include => :address).to_json}
      end
    end
  end

  def messages
    @conversations = Conversation.for_user(current_user).page(params[:page])
    respond_to do |format|
      format.html
      format.js do
        render :json => {:conversations => render_to_string(:partial => "dashboard/messages",
                                                            :locals  => {:conversations => @conversations}),
                         :tabs          => render_to_string(:partial => "dashboard/tabs",
                                                            :locals  => {:active => :messages})
        }
      end
    end
  end

  def map
    @matches = user_signed_in? ? current_user.matches : Apartment.with_state(:published)
    respond_to do |format|
      format.html
      format.js do
        render :json => {:map        => render_to_string(:partial => "dashboard/map"),
                         :map_others => @matches.as_json(:methods => :to_param, :include => :address).to_json}
      end
    end
  end

  def fail
    raise Exception
  end

  private
  def load_events
    component(:activity_feed) do
      @events = current_user.timeline_events[0...5]
    end
  end
end
