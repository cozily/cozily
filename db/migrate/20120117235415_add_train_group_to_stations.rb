class AddTrainGroupToStations < ActiveRecord::Migration
  def self.up
    add_column :stations, :train_group, :string
  end

  def self.down
    remove_column :stations, :train_group
  end
end
