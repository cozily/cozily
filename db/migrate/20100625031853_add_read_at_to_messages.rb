class AddReadAtToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :read_at, :datetime
  end

  def self.down
    remove_column :messages, :read_at
  end
end
