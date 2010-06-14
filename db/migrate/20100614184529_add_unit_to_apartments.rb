class AddUnitToApartments < ActiveRecord::Migration
  def self.up
    add_column :apartments, :unit, :string
  end

  def self.down
    remove_column :apartments, :unit
  end
end
