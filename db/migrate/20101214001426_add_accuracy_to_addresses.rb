class AddAccuracyToAddresses < ActiveRecord::Migration
  def self.up
    add_column :addresses, :accuracy, :integer
  end

  def self.down
    remove_column :addresses, :accuracy
  end
end
