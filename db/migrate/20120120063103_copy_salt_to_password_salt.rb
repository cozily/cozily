class CopySaltToPasswordSalt < ActiveRecord::Migration
  def self.up
    execute("UPDATE users SET password_salt = salt")
  end

  def self.down
    execute("UPDATE users SET password_salt = NULL")
  end
end
