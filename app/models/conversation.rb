class Conversation < ActiveRecord::Base
  belongs_to :apartment
  belongs_to :sender, :class_name => "User"
  belongs_to :receiver, :class_name => "User"
  has_many :messages

  validates_presence_of :apartment, :sender, :receiver
  validate :ensure_sender_is_not_receiver
  validate :ensure_sender_is_email_confirmed, :if => Proc.new { |conversation| conversation.sender.present? }
  validate :ensure_first_message_is_valid

  scope :for_user, lambda { |user| where("(sender_id = ? AND sender_deleted_at IS NULL) OR (receiver_id = ? AND receiver_deleted_at IS NULL)", user.id, user.id) }

  after_create :create_message

  attr_accessor :body

  class << self
    def for_user_and_apartment(user, apartment)
      for_user(user).first(:conditions => {:apartment_id => apartment.id})
    end
  end

  def the_party_who_is_not(user)
    (sender == user ? receiver : sender)
  end

  def unread_message_count_for(user)
    messages.select { |m| m.sender != user && m.read_at.nil? }.size
  end

  def mark_messages_as_read_by(user)
    messages.each { |m| m.update_attribute(:read_at, Time.now) if user != m.sender }
  end

  private
  def ensure_first_message_is_valid
    unless messages.present? || Message.new(:conversation => self, :sender => sender, :body => body).valid?
      errors.add(:base, "The first message is invalid")
    end
  end

  def ensure_sender_is_email_confirmed
    errors.add(:sender, "must confirm their email") unless sender.email_confirmed?
  end

  def ensure_sender_is_not_receiver
    errors.add(:base, "You can't message yourself") if sender == receiver
  end

  def create_message
    messages << Message.create(:sender => sender, :body => body)
  end
end