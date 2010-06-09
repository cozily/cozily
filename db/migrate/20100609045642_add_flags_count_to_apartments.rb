class AddFlagsCountToApartments < ActiveRecord::Migration
  def self.up
    add_column :apartments, :flags_count, :integer, :default => 0
  end

  def self.down
    remove_column :apartments, :flags_count
  end
end
