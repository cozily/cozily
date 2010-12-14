class GeocodeAccuracyForExistingAddresses < ActiveRecord::Migration
  def self.up
    Address.transaction do
      Address.where(:accuracy => nil).each do |address|
        location = GoogleGeocoder.geocode(address.full_address)
        if location.full_address.present? && location.accuracy.present?
          address.update_attribute(:accuracy, location.accuracy)
        end
      end
    end
  end

  def self.down
  end
end
