class AddIndexesToNotifications < ActiveRecord::Migration
  def self.up
    add_index :notifications, :user_id
    add_index :notifications, :apartment_id
  end

  def self.down
    remove_index :notifications, :user_id
    remove_index :notifications, :apartment_id
  end
end
