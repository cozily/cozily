class FavoritesController < ApplicationController
  before_filter :load_user

  def index
    @apartments = @user.favorite_apartments
  end

  def create
    @favorite = @user.favorites.create(params[:favorite])
    @apartment = @favorite.apartment
    render :json => { :favorite_link => render_to_string(:partial => "favorites/link"),
                      :neighborhood_table => render_to_string(:partial => "apartments/table",
                                                              :locals => { :apartments => @favorite.apartment.neighborhood.apartments,
                                                                           :type => "neighborhood" })
    }
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
    @apartment = @favorite.apartment
    render :json => { :favorite_link => render_to_string(:partial => "favorites/link"),
                      :favorites_table => render_to_string(:partial => "apartments/table",
                                                           :locals => { :apartments => @user.favorite_apartments,
                                                                        :type => "favorites" }),
                      :neighborhood_table => render_to_string(:partial => "apartments/table",
                                                              :locals => { :apartments => @favorite.apartment.neighborhood.apartments,
                                                                           :type => "neighborhood" })
    }
  end

  private
  def load_user
    @user = User.find(params[:user_id])
  end
end