class AddStartDateToApartments < ActiveRecord::Migration
  def self.up
    add_column :apartments, :start_date, :date
  end

  def self.down
    remove_column :apartments, :start_date
  end
end
