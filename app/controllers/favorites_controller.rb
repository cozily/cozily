class FavoritesController < ApplicationController
  def create
    @favorite = Favorite.new(params[:favorite])
    @favorite.save
    @apartment = @favorite.apartment
    render :json => { :favorite_link => render_to_string(:partial => "favorites/link") }
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
    @apartment = @favorite.apartment
    render :json => { :favorite_link => render_to_string(:partial => "favorites/link") }
  end
end