class RemoveNeighborhoodIdFromAddresses < ActiveRecord::Migration
  def self.up
    remove_column :addresses, :neighborhood_id
  end

  def self.down
    add_column :addresses, :neighborhood_id, :integer
  end
end
