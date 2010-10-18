class AddNewPetFeatures < ActiveRecord::Migration
  def self.up
    Feature.create(:name => "unknown", :category => "pet")
    Feature.create(:name => "case-by-case", :category => "pet")
  end

  def self.down
    Feature.find_by_name("unknown").try(:destroy)
    Feature.find_by_name("case-by-case").try(:destroy)
  end
end
