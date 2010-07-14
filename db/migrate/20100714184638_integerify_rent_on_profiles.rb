class IntegerifyRentOnProfiles < ActiveRecord::Migration
  def self.up
    change_column :profiles, :rent, :integer
  end

  def self.down
    change_column :profiles, :rent, :float
  end
end
