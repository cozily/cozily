class AddSubletToApartments < ActiveRecord::Migration
  def self.up
    add_column :apartments, :sublet, :boolean, :default => false
  end

  def self.down
    remove_column :apartments, :sublet
  end
end
