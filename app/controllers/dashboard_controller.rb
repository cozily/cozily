class DashboardController < ApplicationController
  def matches
    @matches = Apartment.with_state(:listed)
    @events = current_user.timeline_events[0...5]
    respond_to do |format|
      format.html {}
      format.js do
        render :json => { :matches => render_to_string(:partial => "dashboard/matches") }
      end
    end
  end

  def favorites
    render :json => { :matches => render_to_string(:partial => "dashboard/favorites") }
  end

  def messages
    render :json => { :matches => render_to_string(:partial => "dashboard/messages") }
  end
end