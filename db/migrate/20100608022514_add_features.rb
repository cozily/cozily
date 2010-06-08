class AddFeatures < ActiveRecord::Migration
  def self.up
    Feature.create(:name => "backyard")
    Feature.create(:name => "balcony")
    Feature.create(:name => "bathtub")
    Feature.create(:name => "cats allowed")
    Feature.create(:name => "dishwasher")
    Feature.create(:name => "dogs allowed")
    Feature.create(:name => "doorman")
    Feature.create(:name => "elevator")
    Feature.create(:name => "gym")
    Feature.create(:name => "pool")
    Feature.create(:name => "roof deck")
    Feature.create(:name => "washer/dryer in building")
    Feature.create(:name => "washer/dryer in unit")
  end

  def self.down
  end
end
