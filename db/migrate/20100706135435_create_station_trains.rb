class CreateStationTrains < ActiveRecord::Migration
  def self.up
    create_table :station_trains do |t|
      t.integer :station_id
      t.integer :train_id
      t.timestamps
    end
  end

  def self.down
    drop_table :station_trains
  end
end
