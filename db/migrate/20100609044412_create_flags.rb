class CreateFlags < ActiveRecord::Migration
  def self.up
    create_table :flags do |t|
      t.references :apartment
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :flags
  end
end
