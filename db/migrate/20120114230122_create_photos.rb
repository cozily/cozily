class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.belongs_to :apartment
      t.string :image
      t.string :caption
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
