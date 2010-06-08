class AddStateToApartments < ActiveRecord::Migration
  def self.up
    add_column :apartments, :state, :string
  end

  def self.down
    remove_column :apartments, :state
  end
end
