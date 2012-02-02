class ConvertAddressNeighborhoodsIntoBuildingNeighborhoods < ActiveRecord::Migration
  def self.up
    rename_table :address_neighborhoods, :building_neighborhoods
    rename_column :building_neighborhoods, :address_id, :building_id
  end

  def self.down
    rename_table :building_neighborhoods, :address_neighborhoods
    rename_column :address_neighborhoods, :building_id, :address_id
  end
end
