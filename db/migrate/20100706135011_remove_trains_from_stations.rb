class RemoveTrainsFromStations < ActiveRecord::Migration
  def self.up
    remove_column :stations, :trains
  end

  def self.down
    add_column :stations, :trains, :string
  end
end
