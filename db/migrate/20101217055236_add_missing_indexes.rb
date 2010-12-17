class AddMissingIndexes < ActiveRecord::Migration
  def self.up
      add_index :flags, :user_id
      add_index :flags, :apartment_id
      add_index :user_roles, :role_id
      add_index :user_roles, :user_id
      add_index :apartment_features, :feature_id
      add_index :apartment_features, :apartment_id
      add_index :messages, :conversation_id
      add_index :messages, :sender_id
      add_index :profiles, :user_id
      add_index :apartments, :address_id
      add_index :apartments, :user_id
      add_index :conversations, :apartment_id
      add_index :conversations, :sender_id
      add_index :conversations, :receiver_id
      add_index :favorites, :apartment_id
      add_index :favorites, :user_id
      add_index :neighborhood_profiles, :profile_id
      add_index :neighborhood_profiles, :neighborhood_id
      add_index :timeline_events, [:actor_id, :actor_type]
      add_index :timeline_events, [:secondary_subject_id, :secondary_subject_type], :name => "index_timeline_events_on_ss_id_and_ss_type"
      add_index :timeline_events, [:subject_id, :subject_type]
      add_index :user_activities, :user_id
      add_index :address_neighborhoods, :address_id
      add_index :address_neighborhoods, :neighborhood_id
      add_index :images, :apartment_id
      add_index :station_trains, :train_id
      add_index :station_trains, :station_id
  end

  def self.down
    remove_index :flags, :user_id
    remove_index :flags, :apartment_id
    remove_index :user_roles, :role_id
    remove_index :user_roles, :user_id
    remove_index :apartment_features, :feature_id
    remove_index :apartment_features, :apartment_id
    remove_index :messages, :conversation_id
    remove_index :messages, :sender_id
    remove_index :profiles, :user_id
    remove_index :apartments, :address_id
    remove_index :apartments, :user_id
    remove_index :conversations, :apartment_id
    remove_index :conversations, :sender_id
    remove_index :conversations, :receiver_id
    remove_index :favorites, :apartment_id
    remove_index :favorites, :user_id
    remove_index :neighborhood_profiles, :profile_id
    remove_index :neighborhood_profiles, :neighborhood_id
    remove_index :timeline_events, :column => [:actor_id, :actor_type]
    remove_index :timeline_events, :name => "index_timeline_events_on_ss_id_and_ss_type"
    remove_index :timeline_events, :column => [:subject_id, :subject_type]
    remove_index :user_activities, :user_id
    remove_index :address_neighborhoods, :address_id
    remove_index :address_neighborhoods, :neighborhood_id
    remove_index :images, :apartment_id
    remove_index :station_trains, :train_id
    remove_index :station_trains, :station_id
  end
end
