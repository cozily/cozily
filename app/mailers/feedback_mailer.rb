class FeedbackMailer < ActionMailer::Base
  def feedback(email, message)
    @message = message
    from email
    recipients "support@cozi.ly"
    subject "Cozily Feedback"
  end
end
