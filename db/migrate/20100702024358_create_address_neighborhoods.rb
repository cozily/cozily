class CreateAddressNeighborhoods < ActiveRecord::Migration
  def self.up
    create_table :address_neighborhoods do |t|
      t.references :address
      t.references :neighborhood
      t.timestamps
    end
  end

  def self.down
    drop_table :address_neighborhoods
  end
end
