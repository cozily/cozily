class AddSubletsToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :sublets, :integer, :default => 0
    Profile.update_all(:sublets => 0)
  end

  def self.down
    remove_column :profiles, :sublets
  end
end
