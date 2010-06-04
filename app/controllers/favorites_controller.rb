class FavoritesController < ApplicationController
  def create
    @favorite = Favorite.new(params[:favorite])
    @favorite.save
    redirect_to @favorite.apartment
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
    redirect_to @favorite.apartment
  end
end