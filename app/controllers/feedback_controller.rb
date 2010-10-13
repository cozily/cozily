class FeedbackController < ApplicationController
  def create
    if params[:feedback][:email].present? && params[:feedback][:message].present?
      FeedbackMailer.send_later(:deliver_feedback, params[:feedback][:email], params[:feedback][:message])
      render :json => { :flash => "Thanks for your feedback!" }
    else
      render :json => {}
    end
  end
end