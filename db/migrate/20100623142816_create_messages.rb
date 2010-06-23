class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.references :apartment
      t.references :sender
      t.references :receiver
      t.text       :body
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
