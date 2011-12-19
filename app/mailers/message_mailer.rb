class MessageMailer < ActionMailer::Base
  include Resque::Mailer

  def receiver_notification(message_id)
    @message = Message.find(message_id)

    from "cozily-noreply@cozi.ly"
    recipients @message.receiver.email
    subject "#{@message.sender.full_name} sent you a message on Cozily..."
  end
end
