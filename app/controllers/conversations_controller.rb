class ConversationsController < ApplicationController
  def create
    @conversation = Conversation.find_or_create_by_apartment_id_and_sender_id(params[:conversation].merge(:sender_id => current_user.id))
    unless @conversation.new_record?
      @conversation.messages << Message.create(:body => params[:conversation][:body],
                                               :sender => current_user)
    end
    @conversation.save
    Rails.logger.info @conversation.errors.full_messages
    render :json => { :thread => render_to_string(:partial => "messages/thread",
                                                  :locals => { :apartment => @conversation.apartment })}
  end

  def read
    conversation = Conversation.find(params[:id])
    conversation.mark_messages_as_read_by(current_user)
    render :json => { :inbox => render_to_string(:partial => "dashboard/tabs/messages",
                                                 :locals => { :active => :messages })}
  end
end