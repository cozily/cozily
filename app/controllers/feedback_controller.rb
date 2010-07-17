class FeedbackController < ApplicationController
  def create
    if params[:feedback][:email].present? && params[:feedback][:message].present?
      FeedbackMailer.deliver_feedback(params[:feedback][:email], params[:feedback][:message])
    end

    render :json => { :flash => "Thanks for your feedback!" }
  end
end