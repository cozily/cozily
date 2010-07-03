class WelcomeController < ApplicationController
  def index
    @events = if signed_in?
      current_user.timeline_events
    else
      TimelineEvent.event_type_equals("state_changed_to_listed")
    end
  end
end