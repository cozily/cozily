class CreateTrains < ActiveRecord::Migration
  def self.up
    create_table :trains do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :trains
  end
end
