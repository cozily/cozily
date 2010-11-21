class MessageMailer < ActionMailer::Base
  def receiver_notification(message)
    @message = message
    from "cozily-noreply@cozi.ly"
    recipients message.receiver.email
    subject "#{message.sender.full_name} sent you a message on Cozily..."
  end
end
