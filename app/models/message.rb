class Message < ActiveRecord::Base
  DEFAULT_BODY = "Contact Landlord/Agent..."

  belongs_to :apartment
  belongs_to :sender, :class_name => "User"
  belongs_to :conversation

  validates_presence_of :sender, :body, :conversation
  validate :ensure_body_is_not_default_body
  validate :ensure_sender_is_email_confirmed, :if => Proc.new { |message| message.sender.present? }

  named_scope :unread, :conditions => { :read_at => nil }
  named_scope :sent_by, lambda { |user| { :conditions => ["sender_id = ?", user.id] } }
  named_scope :not_sent_by, lambda { |user| { :conditions => ["sender_id != ?", user.id] } }

  after_create :notify_receiver

  def receiver
    conversation.the_party_who_is_not(sender)
  end

  private
  def ensure_body_is_not_default_body
    errors.add(:body, "must be different than the default") if body == Message::DEFAULT_BODY
  end

  def ensure_sender_is_email_confirmed
    errors.add(:sender, "must confirm their email") unless sender.email_confirmed?
  end

  def notify_receiver
    MessageMailer.deliver_receiver_notification(self)
  end
end
