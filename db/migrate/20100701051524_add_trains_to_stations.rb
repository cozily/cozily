class AddTrainsToStations < ActiveRecord::Migration
  def self.up
    add_column :stations, :trains, :string
  end

  def self.down
    remove_column :stations, :trains
  end
end
