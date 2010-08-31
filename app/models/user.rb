class User < ActiveRecord::Base
  is_gravtastic!
  include Clearance::User

  has_one  :profile, :dependent => :destroy
  has_many :apartments, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_many :flags, :dependent => :destroy
  has_many :favorite_apartments, :through => :favorites, :source => :apartment
  has_many :flagged_apartments, :through => :flags, :source => :apartment
  has_many :messages, :finder_sql => 'select * from messages where sender_id = #{id} or receiver_id = #{id}'
  has_many :received_messages, :class_name => "Message", :foreign_key => "receiver_id"
  has_many :roles, :through => :user_roles
  has_many :sent_messages, :class_name => "Message", :foreign_key => "sender_id"
  has_many :timeline_events, :foreign_key => "actor_id", :dependent => :destroy
  has_many :user_roles, :dependent => :destroy

  validates_presence_of :first_name, :last_name

  def finder?
    role_symbols.include?(:finder) || role_symbols.empty?
  end

  def full_name
    [first_name, last_name].join(" ")
  end

  def lister?
    role_symbols.include?(:lister) || apartments.present?
  end

  def matches
    Apartment.with_state(:listed)
  end

  def role_symbols
     (roles || []).map {|r| r.name.to_sym}
   end

  def unread_message_count
    received_messages.unread.count
  end
end
