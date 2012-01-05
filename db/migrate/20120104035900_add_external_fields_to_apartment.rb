class AddExternalFieldsToApartment < ActiveRecord::Migration
  def self.up
    add_column :apartments, :external_id, :string
    add_column :apartments, :external_url, :string
    add_column :apartments, :external_source, :string
  end

  def self.down
    remove_column :apartments, :external_id, :string
    remove_column :apartments, :external_url, :string
    remove_column :apartments, :external_source, :string
  end
end
