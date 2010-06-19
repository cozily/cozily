class CreateStations < ActiveRecord::Migration
  def self.up
    create_table :stations do |t|
      t.string :name
      t.decimal  "lat", :precision => 15, :scale => 10
      t.decimal  "lng", :precision => 15, :scale => 10      
      t.timestamps
    end
  end

  def self.down
    drop_table :stations
  end
end
