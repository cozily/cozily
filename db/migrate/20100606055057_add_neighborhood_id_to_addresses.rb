class AddNeighborhoodIdToAddresses < ActiveRecord::Migration
  def self.up
    add_column :addresses, :neighborhood_id, :integer
  end

  def self.down
    remove_column :addresses, :neighborhood_id
  end
end
