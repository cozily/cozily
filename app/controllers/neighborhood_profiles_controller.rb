class NeighborhoodProfilesController < ApplicationController
  def destroy
    @neighborhood_profile = NeighborhoodProfile.find(params[:id])
    @neighborhood_profile.destroy
    render :json => {}
  end
end