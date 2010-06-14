class AddContactIdToApartments < ActiveRecord::Migration
  def self.up
    add_column :apartments, :contact_id, :integer
  end

  def self.down
    remove_column :apartments, :contact_id
  end
end
