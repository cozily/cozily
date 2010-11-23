class RemoveUnknownFromFeatures < ActiveRecord::Migration
  def self.up
    Feature.find_by_name("unknown").try(:destroy)
  end

  def self.down
    Feature.create(:name => "unknown", :category => "pet")
  end
end
