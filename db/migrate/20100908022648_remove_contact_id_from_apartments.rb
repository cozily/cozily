class RemoveContactIdFromApartments < ActiveRecord::Migration
  def self.up
    remove_column :apartments, :contact_id
  end

  def self.down
    add_column :apartments, :contact_id, :integer
  end
end
