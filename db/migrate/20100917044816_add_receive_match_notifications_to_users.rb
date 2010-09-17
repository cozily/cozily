class AddReceiveMatchNotificationsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :receive_match_notifications, :boolean, :default => true
    User.update_all({:receive_match_notifications => true}, {:receive_match_notifications => nil})
  end

  def self.down
    remove_column :users, :receive_match_notifications
  end
end
