class MessagesController < ApplicationController
  before_filter :load_apartment

  def create
    @message = @apartment.messages.build(params[:message].merge(:sender_id => current_user.id))
    @message.save
    redirect_to :back
  end

  private
  def load_apartment
    @apartment = Apartment.find(params[:apartment_id])
  end
end
