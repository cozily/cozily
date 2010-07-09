class Users::ProfilesController < ApplicationController
  def edit
    current_user.profile ||= Profile.new
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