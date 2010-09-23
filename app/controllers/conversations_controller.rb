class ConversationsController < ApplicationController
  def destroy
    conversation = Conversation.find(params[:id])
    if conversation.sender == current_user
      conversation.update_attribute(:sender_deleted_at, Time.now)
    else
      conversation.update_attribute(:receiver_deleted_at, Time.now)
    end
    render :json => { :flash => "Conversation deleted!" }
  end

  def read
    conversation = Conversation.find(params[:id])
    conversation.mark_messages_as_read_by(current_user)
    render :json => { :inbox => render_to_string(:partial => "dashboard/tabs/messages",
                                                 :locals => { :active => :messages })}
  end
end
