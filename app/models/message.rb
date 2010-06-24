class Message < ActiveRecord::Base
  belongs_to :apartment
  belongs_to :sender, :class_name => "User"
  belongs_to :receiver, :class_name => "User"

  validates_presence_of :apartment, :sender, :receiver, :body

  named_scope :for_user, lambda { |user|
    { :conditions => ["sender_id = ? or receiver_id = ?", user.id, user.id] }
  }

  after_create :notify_receiver

  private
  def notify_receiver
    MessageMailer.deliver_receiver_notification(self)
  end
end
