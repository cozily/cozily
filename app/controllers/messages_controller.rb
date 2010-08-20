class MessagesController < ApplicationController
  def create
    if params[:apartment_id]
      @apartment = Apartment.find(params[:apartment_id])
      @message = @apartment.messages.build(params[:message].merge(:sender_id => current_user.id))
      @message.save
      render :json => { :thread => render_to_string(:partial => "messages/thread",
                                                    :locals => { :messages => @apartment.messages.for_user(current_user) })}
    elsif params[:message_id]
      @message = Message.find(params[:message_id])
      Message.create(params[:message].merge(:sender_id => current_user.id))
      render :json => { :replies => render_to_string(:partial => "dashboard/messages/replies",
                                                     :locals => { :message => @message })}
    end
  end
end
