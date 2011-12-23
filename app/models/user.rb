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
  has_many :conversations, :finder_sql => proc { "select * from conversations where sender_id = #{id} or receiver_id = #{id}" }
  has_many :messages, :through => :conversations

  validates_presence_of :first_name, :last_name
  validates_presence_of :phone, :if => Proc.new { |user| user.lister? }
  validates_length_of :phone, :is => 10, :allow_nil => true, :allow_blank => true
  validate :ensure_has_role

  before_validation :format_phone

  accepts_nested_attributes_for :profile

  scope :email_confirmed, where(:email_confirmed => true)
  scope :receive_match_notifications, where(:receive_match_notifications => true)
  scope :receive_match_summaries, where(:receive_match_summaries => true)
  scope :receive_listing_summaries, where(:receive_listing_summaries => true)

  scope :finder, lambda { joins(:roles).where("roles.id = ?", Role.find_by_name("finder")) }
  scope :lister, lambda { joins(:roles).where("roles.id = ?", Role.find_by_name("lister")) }

  class << self
    def send_finder_summary_emails
      User.finder.receive_match_summaries.each do |user|
        UserMailer.finder_summary(user.id).deliver
      end
    end

    def send_lister_summary_emails
      User.lister.receive_listing_summaries.each do |user|
        UserMailer.lister_summary(user.id).deliver
      end
    end
  end

  def admin?
    is_admin?
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
    apts = Apartment.order("published_at desc").where("user_id != ?", self.id).with_state(:published)
    apts = apts.where("rent <= ?", profile.rent) if profile.try(:rent)
    apts = apts.where("bedrooms >= ? ", profile.bedrooms) if profile.try(:bedrooms)

    if profile.try(:only_sublets?)
      apts = apts.where(:sublet => true)
    elsif profile.try(:exclude_sublets?)
      apts = apts.where(:sublet => false)
    end

    if profile.try(:neighborhoods).try(:present?)
      ids = apts.select { |a| (a.neighborhoods.merge profile.neighborhoods).present? }.map(&:id)
      Apartment.where(:id => ids)
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
    ClearanceMailer.confirmation(self.id).deliver
  end

  private
  def ensure_has_role
    errors.add(:roles, "can't be empty") if roles.empty?
  end

  def format_phone
    self.phone = phone.gsub(/[^0-9]/, "") if phone.present?
  end
end
