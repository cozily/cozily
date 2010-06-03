class CreateApartments < ActiveRecord::Migration
  def self.up
    create_table :apartments do |t|
      t.references :address
      t.float :rent
      t.float :bedrooms
      t.float :bathrooms
      t.float :square_footage
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :apartments
  end
end
