class CleanUpUsersTable < ActiveRecord::Migration
  def self.up
    remove_column :users, :email_confirmation
    remove_column :users, :confirmation_token
  end

  def self.down
  end
end
