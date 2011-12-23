class MoveAdminFlagToUserAndRemoveRole < ActiveRecord::Migration
  def self.up
    add_column :users, :is_admin, :boolean, :null => false, :default => false

    Role.find_by_name("admin").try(:destroy)
  end

  def self.down
    remove_column :users, :is_admin

    Role.create(:name => "admin")
  end
end
