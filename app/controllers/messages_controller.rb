class MessagesController < ApplicationController
  def create
    @message = Message.create(params[:message].merge(:sender_id => current_user.id))
    render :json => { :replies => render_to_string(:partial => "dashboard/messages/messages",
                                                     :locals => { :conversation => @message.conversation })}
  end
end
