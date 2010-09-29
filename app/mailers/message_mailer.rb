class MessageMailer < ActionMailer::Base
  def receiver_notification(message)
    from "cozily-noreply@cozi.ly"
    recipients message.receiver.email
    subject "#{message.sender.full_name} sent you a message on Cozily..."
    body :message => message
  end
end
