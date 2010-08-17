class AddViewsCountToApartments < ActiveRecord::Migration
  def self.up
    add_column :apartments, :views_count, :integer, :default => 0
    Apartment.reset_column_information
    Apartment.all.each do |apartment|
      apartment.update_attribute(:views_count, 0)
    end
  end

  def self.down
    remove_column :apartments, :views_count
  end
end
