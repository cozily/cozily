class ConvertAddressesIntoBuildings < ActiveRecord::Migration
  def self.up
    rename_table :addresses, :buildings
    rename_column :apartments, :address_id, :building_id
  end

  def self.down
    rename_table :buildings, :addresses
    rename_column :apartments, :building_id, :address_id
  end
end
