class User < ActiveRecord::Base
  is_gravtastic!
  include Clearance::User

  has_one :profile, :dependent => :destroy
  has_many :activities, :class_name => "UserActivity", :dependent => :destroy
  has_many :apartments, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_many :flags, :dependent => :destroy
  has_many :favorite_apartments, :through => :favorites, :source => :apartment
  has_many :flagged_apartments, :through => :flags, :source => :apartment
  has_many :user_roles, :dependent => :destroy
  has_many :roles, :through => :user_roles
  has_many :timeline_events, :foreign_key => "actor_id", :dependent => :destroy
  has_many :conversations, :finder_sql => 'select * from conversations where sender_id = #{id} or receiver_id = #{id}'
  has_many :messages, :through => :conversations

  validates_presence_of :first_name, :last_name
  validates_presence_of :phone, :if => Proc.new { |user| user.lister? }
  validates_length_of :phone, :is => 10, :allow_nil => true, :allow_blank => true
  validate :ensure_has_role

  before_validation :format_phone

  accepts_nested_attributes_for :profile

  named_scope :email_confirmed, :conditions => {:email_confirmed => true}
  named_scope :receive_match_notifications, :conditions => {:receive_match_notifications => true}

  class << self
    def finder
      User.scoped({:joins => :roles, :conditions => ["roles.id = ?", Role.find_by_name("finder")]})
    end
  end

  def admin?
    roles.include?(Role.find_by_name("admin"))
  end

  def finder?
    role_symbols.include?(:finder) || role_symbols.empty?
  end

  def full_name
    [first_name, last_name].join(" ")
  end

  def has_activity_today?
    UserActivity.exists?(:user_id => self, :date => Date.today)
  end

  def has_received_first_apartment_notification?
    FirstApartmentNotification.exists?(:user_id => self.id)
  end

  def has_received_match_notification_for?(apartment)
    MatchNotification.exists?(:user_id => self.id, :apartment_id => apartment.id)
  end

  def lister?
    role_symbols.include?(:lister) || apartments.present?
  end

  def matches
    apts = Apartment.user_id_does_not_equal(self.id).with_state(:published)
    apts = apts.rent_lte(profile.rent) if profile.try(:rent)
    apts = apts.bedrooms_gte(profile.bedrooms) if profile.try(:bedrooms)
    if profile.try(:neighborhoods).try(:present?)
      apts.select { |a| (a.neighborhoods & profile.neighborhoods).present? }
    else
      apts
    end
  end

  def role_symbols
    (roles || []).map { |r| r.name.to_sym }
  end

  def unread_message_count
    received_messages.select { |m| m.read_at.nil? }.size
  end

  def received_messages
    conversations.map(&:messages).flatten.select { |m| m.sender_id != id }
#    messages.not_sent_by(self)
  end

  def sent_messages
    conversations.map(&:messages).flatten.select { |m| m.sender_id == id }
#    messages.sent_by(self)
  end

  def send_confirmation_email
    ClearanceMailer.send_later(:deliver_confirmation, self)
  end

  private
  def ensure_has_role
    errors.add(:roles, "can't be empty") if roles.empty?
  end

  def format_phone
    self.phone = phone.gsub(/[^0-9]/, "") if phone.present?
  end
end
