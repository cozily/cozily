class NeighborhoodProfilesController < ApplicationController
  def create
    neighborhood = Neighborhood.find(params[:neighborhood_id])
    if neighborhood_profile = NeighborhoodProfile.find_by_neighborhood_id_and_profile_id(neighborhood.id, current_user.profile.id)
      neighborhood_profile.destroy
    else
      NeighborhoodProfile.create(:neighborhood => neighborhood,
                                 :profile => current_user.profile)
    end
    render :json => {:neighborhood_profile_link => render_to_string(:partial => "users/profiles/neighborhood_link",
                                                                    :locals => {:neighborhood => neighborhood})}
  end

  def destroy
    @neighborhood_profile = NeighborhoodProfile.find(params[:id])
    @neighborhood_profile.destroy
    render :json => {}
  end
end