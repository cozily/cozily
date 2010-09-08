class Message < ActiveRecord::Base
  belongs_to :apartment
  belongs_to :sender, :class_name => "User"
  belongs_to :conversation

  validates_presence_of :sender, :body, :conversation

  named_scope :unread, :conditions => { :read_at => nil }
  named_scope :sent_by, lambda { |user| { :conditions => ["sender_id = ?", user.id] } }
  named_scope :not_sent_by, lambda { |user| { :conditions => ["sender_id != ?", user.id] } }

  after_create :notify_receiver

  def receiver
    conversation.the_party_who_is_not(sender)
  end

  private
  def notify_receiver
    MessageMailer.deliver_receiver_notification(self)
  end
end
