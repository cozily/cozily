class Message < ActiveRecord::Base
  belongs_to :apartment
  belongs_to :sender, :class_name => "User"
  belongs_to :receiver, :class_name => "User"
  belongs_to :parent, :class_name => "Message"

  has_many :replies, :class_name => "Message", :foreign_key => "parent_id"

  validates_presence_of :apartment, :sender, :receiver, :body
  validate :ensure_sender_is_not_receiver

  named_scope :for_user, lambda { |user| { :conditions => ["sender_id = ? or receiver_id = ?", user.id, user.id] } }
  named_scope :root, :conditions => { :parent_id => nil }
  named_scope :unread, :conditions => { :read_at => nil }

  after_create :notify_receiver

  def latest_reply
    Message.parent_id_equals(id).descend_by_created_at.first
  end

  def thread
    if parent_id
      [parent] | [Message.parent_id_equals(parent_id)]
    else
      [self]
    end.flatten
  end

  private
  def notify_receiver
    MessageMailer.deliver_receiver_notification(self)
  end

  def ensure_sender_is_not_receiver
    errors.add_to_base("You can't message yourself") if sender == receiver
  end
end
