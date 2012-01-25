class AddDeviseToUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      t.recoverable
      t.rememberable
      t.trackable
      t.encryptable
    end

    add_index :users, :reset_password_token, :unique => true
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
