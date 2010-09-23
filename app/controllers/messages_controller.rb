class MessagesController < ApplicationController
  def create
    if params[:apartment_id]
      @apartment = Apartment.find(params[:apartment_id])
      @conversation = Conversation.find_or_initialize_by_apartment_id_and_sender_id(@apartment.id, current_user.id)
      if @conversation.new_record?
        @conversation.update_attributes(params[:message].merge(:receiver_id => @apartment.user_id))
        @conversation.save
      else
        @conversation.messages.create(params[:message].merge(:sender_id => current_user.id))
      end
      render :json => { :flash => "Message Sent!",
                        :thread => render_to_string(:partial => "messages/thread",
                                                    :locals => { :apartment => @apartment })}
    elsif params[:conversation_id]
      @conversation = Conversation.find(params[:conversation_id])
      @conversation.messages.create(params[:message].merge(:sender_id => current_user.id))
      render :json => { :flash => "Message Sent!",
                        :replies => render_to_string(:partial => "dashboard/messages/messages",
                                                     :locals => { :conversation => @conversation })}
    else
      raise "You can't create a conversation without an Apartment or Conversation."
    end
  end
end
