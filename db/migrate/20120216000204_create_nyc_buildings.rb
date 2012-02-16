class CreateNycBuildings < ActiveRecord::Migration
  def self.up
    create_table :nyc_buildings do |t|
      t.string :boro, :limit => 1
      t.string :block, :limit => 5
      t.string :lot, :limit => 4
      t.string :bin, :limit => 7
      t.string :lhnd, :limit => 12
      t.string :lhns, :limit => 11
      t.string :lcontpar, :limit => 1
      t.string :lsos, :limit => 1
      t.string :hhnd, :limit => 12
      t.string :hhns, :limit => 11
      t.string :hcontpar, :limit => 1
      t.string :hsos, :limit => 1
      t.string :scboro, :limit => 1
      t.string :sc5, :limit => 5
      t.string :sclgc, :limit => 2
      t.string :stname, :limit => 32
      t.string :addrtype, :limit => 1
      t.string :realb7sc, :limit => 8
      t.string :validlgcs, :limit => 8
      t.string :parity, :limit => 1
      t.string :b10sc, :limit => 11
      t.string :segid, :limit => 7
    end
  end

  def self.down
    drop_table :nyc_buildings
  end
end
