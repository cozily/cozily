class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table "addresses" do |t|
      t.string   "street"
      t.string   "city"
      t.string   "state"
      t.string   "zip"
      t.string   "full_address"
      t.decimal  "lat",     :precision => 15, :scale => 10
      t.decimal  "lng",    :precision => 15, :scale => 10
      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
