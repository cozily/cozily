class AddNewFeatures < ActiveRecord::Migration
  def self.up
    add_column :features, :category, :string

    Feature.create(:name => "furnished", :category => "apartment")
    Feature.create(:name => "exposed brick", :category => "apartment")
    Feature.create(:name => "sleeping loft", :category => "apartment")
    Feature.create(:name => "high ceilings", :category => "apartment")
    Feature.create(:name => "air conditioning", :category => "apartment")

    Feature.create(:name => "high-rise", :category => "building")
    Feature.create(:name => "live-in super", :category => "building")
  end

  def self.down
    remove_column :features, :category

    ["furnished", "exposed brick", "sleeping loft", "high ceilings",
     "air conditioning", "high-rise","live-in super"].each do |feature|
      Feature.find_by_name(feature).try(:destroy)
    end
  end
end
