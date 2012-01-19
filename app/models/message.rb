class Message < ActiveRecord::Base
  belongs_to :sender, :class_name => "User"
  belongs_to :conversation

  validates_presence_of :sender, :body, :conversation
  # validate :ensure_body_is_not_default_body
  validate :ensure_sender_is_email_confirmed, :if => Proc.new { |message| message.sender.present? }

  scope :unread, where(:read_at => nil)
  scope :sent_by, lambda { |user| where("sender_id = ?", user.id) }
  scope :not_sent_by, lambda { |user| where("sender_id != ?", user.id) }

  after_create :notify_receiver
  after_create :undelete_conversation

  def receiver
    conversation.the_party_who_is_not(sender)
  end

  private
  def ensure_sender_is_email_confirmed
    errors.add(:sender, "must confirm their email") unless sender.email_confirmed?
  end

  def notify_receiver
    MessageMailer.receiver_notification(self.id).deliver
  end

  def undelete_conversation
    conversation.update_attributes(:sender_deleted_at => nil,
                                   :receiver_deleted_at => nil)
    conversation.save
  end
end
