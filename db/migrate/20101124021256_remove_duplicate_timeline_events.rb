class RemoveDuplicateTimelineEvents < ActiveRecord::Migration
  def self.up
    Apartment.all.each do |apt|
      events = TimelineEvent.where(:subject_id => apt.id,
                                   :event_type => "state_changed_to_published")
      if events.size > 1
        first_event = events.shift
        events.each do |event|
          diff = first_event.created_at.to_i - event.created_at.to_i
          event.destroy if diff < 60
        end
      end
    end
  end

  def self.down
  end
end
