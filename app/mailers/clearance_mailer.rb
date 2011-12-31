class ClearanceMailer < ActionMailer::Base
  include Resque::Mailer

  def change_password(user_param)
    @user = User.find(user_param["user"]["id"])
    from       Clearance.configuration.mailer_sender
    recipients @user.email
    subject    I18n.t(:change_password,
                      :scope   => [:clearance, :models, :clearance_mailer],
                      :default => "Change your password")
  end

  def confirmation(user_id)
    @user = User.find(user_id)
    from       Clearance.configuration.mailer_sender
    recipients @user.email
    subject    I18n.t(:confirmation,
                      :scope   => [:clearance, :models, :clearance_mailer],
                      :default => "Confirm your email address")
  end
end
