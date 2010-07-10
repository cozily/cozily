class IntegerifyRentAndSquareFootageOnApartments < ActiveRecord::Migration
  def self.up
    change_column :apartments, :rent, :integer
    change_column :apartments, :square_footage, :integer
  end

  def self.down
    change_column :apartments, :rent, :float
    change_column :apartments, :square_footage, :float
  end
end
