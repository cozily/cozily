class FavoritesController < ApplicationController
  before_filter :load_user

  def index
    @favorite_apartments = @user.favorite_apartments
  end

  def create
    @favorite = @user.favorites.create(params[:favorite])
    @apartment = @favorite.apartment
    render :json => { :favorite_link => render_to_string(:partial => "favorites/link") }
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
    @apartment = @favorite.apartment
    @favorite_apartments = @user.favorite_apartments
    render :json => { :favorite_link => render_to_string(:partial => "favorites/link"),
                      :favorites_table => render_to_string(:partial => "favorites/table") }
  end

  private
  def load_user
    @user = User.find(params[:user_id])
  end
end