class AddWeeklySummaryBooleansToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :receive_match_summaries, :boolean, :default => true
    add_column :users, :receive_listing_summaries, :boolean, :default => true
    User.update_all({:receive_match_summaries => true}, {:receive_match_summaries => nil})
    User.update_all({:receive_listing_summaries => true}, {:receive_listing_summaries => nil})
  end

  def self.down
    remove_column :users, :receive_match_summaries
    remove_column :users, :receive_listing_summaries
  end
end
