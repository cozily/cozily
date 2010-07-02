class FavoritesController < ApplicationController
  load_and_authorize_resource :nested => :user

  def index
    raise CanCan::AccessDenied unless @user == current_user
    @apartments = @user.favorite_apartments.with_state(:listed)
  end

  def create
    @favorite = @user.favorites.create(params[:favorite])
    render :json => { :favorite_link => render_to_string(:partial => "favorites/link",
                                                         :locals => { :apartment => @favorite.apartment }),
                      :neighborhood_table => render_to_string(:partial => "apartments/table",
                                                              :locals => { :apartments => @favorite.apartment.neighborhood.apartments.with_state(:listed),
                                                                           :type => "neighborhood" })
    }
  end

  def destroy
    @favorite = @user.favorites.find(params[:id])
    @favorite.destroy
    render :json => { :favorite_link => render_to_string(:partial => "favorites/link",
                                                         :locals => { :apartment => @favorite.apartment }),
                      :favorites_table => render_to_string(:partial => "apartments/table",
                                                           :locals => { :apartments => @user.favorite_apartments.with_state(:listed),
                                                                        :type => "favorites" }),
                      :neighborhood_table => render_to_string(:partial => "apartments/table",
                                                              :locals => { :apartments => @favorite.apartment.neighborhood.apartments.with_state(:listed),
                                                                           :type => "neighborhood" })
    }
  end
end
