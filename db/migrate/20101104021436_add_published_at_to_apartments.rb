class AddPublishedAtToApartments < ActiveRecord::Migration
  def self.up
    add_column :apartments, :published_at, :datetime
    Apartment.transaction do
      Apartment.all.each do |apt|
        published_at = apt.subject_timeline_events.event_type_equals("state_changed_to_published").first.try(:created_at)
        next unless published_at
        apt.update_attribute(:published_at, published_at)
      end
    end
  end

  def self.down
    remove_column :apartments, :published_at
  end
end
