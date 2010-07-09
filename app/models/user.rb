class User < ActiveRecord::Base
  is_gravtastic!
  include Clearance::User

  has_many :apartments, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_many :flags, :dependent => :destroy
  has_many :favorite_apartments, :through => :favorites, :source => :apartment
  has_many :flagged_apartments, :through => :flags, :source => :apartment
  has_many :messages, :finder_sql => 'select * from messages where sender_id = #{id} or receiver_id = #{id}'
  has_one  :profile, :dependent => :destroy
  has_many :received_messages, :class_name => "Message", :foreign_key => "receiver_id"
  has_many :sent_messages, :class_name => "Message", :foreign_key => "sender_id"

  validates_presence_of :first_name, :last_name

  def full_name
    [first_name, last_name].join(" ")
  end

  def timeline_events
    TimelineEvent.actor_id_equals(self.id) | TimelineEvent.event_type_equals("state_changed_to_listed")
  end

  def unread_message_count
    received_messages.unread.count
  end
end
