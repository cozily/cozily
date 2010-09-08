class Users::ProfilesController < ApplicationController
  def edit
    @user = User.find(params[:user_id])
    @user.profile ||= Profile.new
    respond_to do |format|
      format.html {}
      format.js do
        render :json => { :form => render_to_string(:partial => "users/profiles/edit") }
      end
    end
  end
end