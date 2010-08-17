class AddFavoritesCountToApartment < ActiveRecord::Migration
  def self.up
    add_column :apartments, :favorites_count, :integer, :default => 0
    Apartment.reset_column_information
    Apartment.all.each do |apartment|
      apartment.update_attribute(:favorites_count, apartment.favorites.length)
    end
  end

  def self.down
    remove_column :apartments, :favorites_count
  end
end
