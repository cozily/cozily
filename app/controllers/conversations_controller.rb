class ConversationsController < ApplicationController
  def create
      @apartment = Apartment.find(params[:apartment_id])
      @conversation = @apartment.conversations.build(params[:conversation].merge(:sender_id => current_user.id))
      @conversation.save
      render :json => { :thread => render_to_string(:partial => "messages/thread",
                                                    :locals => { :conversations => @apartment.conversations.for_user(current_user) })}
  end
end