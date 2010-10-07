class UpdateStatesToPublishedAndUnpublished < ActiveRecord::Migration
  def self.up
    Apartment.update_all({:state => 'published'}, {:state => 'listed'})
    Apartment.update_all({:state => 'unpublished'}, {:state => 'unlisted'})
    TimelineEvent.update_all({:event_type => 'state_changed_to_published'}, {:event_type => 'state_changed_to_listed'})
    TimelineEvent.update_all({:event_type => 'state_changed_to_unpublished'}, {:event_type => 'state_changed_to_unlisted'})
  end

  def self.down
    Apartment.update_all({:state => 'listed'}, {:state => 'published'})
    Apartment.update_all({:state => 'unlisted'}, {:state => 'unpublished'})
    TimelineEvent.update_all({:event_type => 'state_changed_to_listed'}, {:event_type => 'state_changed_to_published'})
    TimelineEvent.update_all({:event_type => 'state_changed_to_unlisted'}, {:event_type => 'state_changed_to_unpublished'})
  end
end
