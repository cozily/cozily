class AddLineToStations < ActiveRecord::Migration
  def self.up
    add_column :stations, :line, :string
  end

  def self.down
    remove_column :stations, :line
  end
end
