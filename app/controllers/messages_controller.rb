class MessagesController < ApplicationController
  before_filter :load_apartment

  def create
    @message = @apartment.messages.build(params[:message].merge(:sender_id => current_user.id))
    @message.save
    render :json => { :thread => render_to_string(:partial => "messages/thread",
                                                  :locals => { :messages => @apartment.messages.for_user(current_user) })
    }
  end

  private
  def load_apartment
    @apartment = Apartment.find(params[:apartment_id])
  end
end
