class CreateApartmentFeatures < ActiveRecord::Migration
  def self.up
    create_table :apartment_features do |t|
      t.references :apartment
      t.references :feature
      t.timestamps
    end
  end

  def self.down
    drop_table :apartment_features
  end
end
