class AddPhotosCountToApartment < ActiveRecord::Migration
  def self.up
    add_column :apartments, :photos_count, :integer
  end

  def self.down
    remove_column :apartments, :photos_count
  end
end
