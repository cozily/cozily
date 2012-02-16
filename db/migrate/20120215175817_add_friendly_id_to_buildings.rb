class AddFriendlyIdToBuildings < ActiveRecord::Migration
  def self.up
    Building.find_each(&:save)
  end

  def self.down
    Slug.destroy_all({:sluggable_type => "Building"})
  end
end
