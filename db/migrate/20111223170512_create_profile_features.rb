class CreateProfileFeatures < ActiveRecord::Migration
  def self.up
    create_table :profile_features do |t|
      t.references :profile
      t.references :feature
      t.timestamps
    end
  end

  def self.down
    drop_table :profile_features
  end
end
