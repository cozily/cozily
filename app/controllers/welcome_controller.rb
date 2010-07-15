class WelcomeController < ApplicationController
  def index
    if signed_in?
      @events = current_user.timeline_events
    else
      render "unauthenticated"
    end
  end
end