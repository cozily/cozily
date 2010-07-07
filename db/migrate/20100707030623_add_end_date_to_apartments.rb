class AddEndDateToApartments < ActiveRecord::Migration
  def self.up
    add_column :apartments, :end_date, :date
  end

  def self.down
    remove_column :apartments, :end_date
  end
end
