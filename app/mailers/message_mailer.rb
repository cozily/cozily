class MessageMailer < ActionMailer::Base
  def receiver_notification(message)
    from "support@cozi.ly"
    recipients message.receiver.email
    subject "Someone sent you a message on Cozily..."
    body :message => message
  end
end