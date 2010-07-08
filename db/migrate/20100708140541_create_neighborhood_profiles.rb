class CreateNeighborhoodProfiles < ActiveRecord::Migration
  def self.up
    create_table :neighborhood_profiles do |t|
      t.integer :neighborhood_id
      t.integer :profile_id
      t.timestamps
    end
  end

  def self.down
    drop_table :neighborhood_profiles
  end
end
