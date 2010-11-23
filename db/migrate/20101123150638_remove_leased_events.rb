class RemoveLeasedEvents < ActiveRecord::Migration
  def self.up
    TimelineEvent.where(:event_type => "state_changed_to_leased").destroy_all
  end

  def self.down
  end
end
