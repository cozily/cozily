class AddImagesCountToApartments < ActiveRecord::Migration
  def self.up
    add_column :apartments, :images_count, :integer, :default => 0
  end

  def self.down
    remove_column :apartments, :images_count
  end
end
