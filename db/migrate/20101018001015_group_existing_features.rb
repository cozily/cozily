class GroupExistingFeatures < ActiveRecord::Migration
  def self.up
    Feature.find_by_name("cats allowed").update_attribute(:category, "pet")
    Feature.find_by_name("dogs allowed").update_attribute(:category, "pet")

    Feature.find_by_name("bathtub").update_attribute(:category, "apartment")
    Feature.find_by_name("balcony").update_attribute(:category, "apartment")
    Feature.find_by_name("bathtub").update_attribute(:category, "apartment")
    Feature.find_by_name("dishwasher").update_attribute(:category, "apartment")

    Feature.find_by_name("doorman").update_attribute(:category, "building")
    Feature.find_by_name("elevator").update_attribute(:category, "building")
    Feature.find_by_name("gym").update_attribute(:category, "building")
    Feature.find_by_name("pool").update_attribute(:category, "building")
    Feature.find_by_name("roof deck").update_attribute(:category, "building")

    Feature.find_by_name("washer/dryer in building").update_attributes({:category => "building", :name => "washer/dryer"})
    Feature.find_by_name("washer/dryer in unit").update_attributes({:category => "apartment", :name => "washer/dryer"})
  end

  def self.down
    # not worth doing
  end
end
