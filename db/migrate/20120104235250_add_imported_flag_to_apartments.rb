class AddImportedFlagToApartments < ActiveRecord::Migration
  def self.up
    add_column :apartments, :imported, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :apartments, :imported
  end
end
