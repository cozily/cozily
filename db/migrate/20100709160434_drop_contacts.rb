class DropContacts < ActiveRecord::Migration
  def self.up
    drop_table :contacts
  end

  def self.down
    create_table :contacts do |t|
      t.references :user
      t.string :name
      t.string :email
      t.string :phone
      t.timestamps
    end    
  end
end
