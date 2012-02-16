class CreateNycTaxLots < ActiveRecord::Migration
  def self.up
    create_table :nyc_tax_lots do |t|
      t.string :loboro, :limit => 1
      t.string :loblock, :limit => 5
      t.string :lolot, :limit => 4
      t.string :lobblssc, :limit => 1
      t.string :hiboro, :limit => 1
      t.string :hiblock, :limit => 5
      t.string :hilot, :limit => 4
      t.string :hibblssc, :limit => 1
      t.string :boro, :limit => 1
      t.string :block, :limit => 5
      t.string :lot, :limit => 4
      t.string :bblssc, :limit => 1
      t.string :billboro, :limit => 1
      t.string :billblock, :limit => 5
      t.string :billlot, :limit => 4
      t.string :billbblssc, :limit => 1
      t.string :condoflag, :limit => 1
      t.string :condonum, :limit => 4
      t.string :coopnum, :limit => 4
      t.string :numbf, :limit => 2
      t.string :numaddr, :limit => 4
      t.string :vacant, :limit => 1
      t.string :interior, :limit => 1
    end
  end

  def self.down
    drop_table :nyc_tax_lots
  end
end
