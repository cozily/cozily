class Users::ProfilesController < ApplicationController
  def edit
    current_user.profile ||= Profile.new
    respond_to do |format|
      format.html {}
      format.js do
        render :json => { :form => render_to_string(:partial => "users/profiles/edit") }
      end
    end
  end

  def update
    @profile = current_user.profile
    if @profile.update_attributes(params[:profile])
      redirect_to root_path
    else
      render :edit
    end
  end
end