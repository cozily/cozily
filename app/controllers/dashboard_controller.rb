class DashboardController < ApplicationController
  def show
    @events = current_user.timeline_events[0...5]
  end
end