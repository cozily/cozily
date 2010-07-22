class DashboardController < ApplicationController
  def show
    @matches = Apartment.with_state(:listed)
    @events = current_user.timeline_events[0...5]
  end
end