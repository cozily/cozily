class CreateNeighborhoods < ActiveRecord::Migration
  def self.up
    create_table :neighborhoods do |t|
      t.string :name
      t.string :city
      t.string :state
      t.string :country
      t.string :borough
      t.timestamps
    end
  end

  def self.down
    drop_table :neighborhoods
  end
end
