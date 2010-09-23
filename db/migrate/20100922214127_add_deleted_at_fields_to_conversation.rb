class AddDeletedAtFieldsToConversation < ActiveRecord::Migration
  def self.up
    add_column :conversations, :sender_deleted_at, :datetime
    add_column :conversations, :receiver_deleted_at, :datetime
  end

  def self.down
    remove_column :conversations, :sender_deleted_at
    remove_column :conversations, :receiver_deleted_at
  end
end
