class RemoveDescriptionFromApartments < ActiveRecord::Migration
  def self.up
    remove_column :apartments, :description
  end

  def self.down
    add_column :apartments, :description, :text
  end
end
