class AlterBedroomsOnProfiles < ActiveRecord::Migration
  def self.up
    change_column :profiles, :bedrooms, :integer
  end

  def self.down
    change_column :profiles, :bedrooms, :float
  end
end
