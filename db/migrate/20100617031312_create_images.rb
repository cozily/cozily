class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.references :apartment
      t.string     :caption
      t.string     :asset_file_name
      t.string     :asset_content_type
      t.integer    :asset_file_size
      t.datetime   :asset_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
