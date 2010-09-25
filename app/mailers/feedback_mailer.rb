class FeedbackMailer < ActionMailer::Base
  def feedback(email, message)
    from email
    recipients "support@cozi.ly"
    subject "Cozily Feedback"
    body :message => message
  end
end
