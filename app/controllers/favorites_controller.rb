class FavoritesController < ApplicationController
  before_filter :load_user

  def create
    @favorite = @user.favorites.create(params[:favorite])
    authorize! :create, @favorite

    render :json => { :favorite_link => render_to_string(:partial => "favorites/link",
                                                         :locals => { :apartment => @favorite.apartment,
                                                                      :count => params[:count] })
    }
  end

  def destroy
    @favorite = @user.favorites.find(params[:id])
    authorize! :destroy, @favorite

    @favorite.destroy
    render :json => { :favorite_link => render_to_string(:partial => "favorites/link",
                                                         :locals => { :apartment => @favorite.apartment,
                                                                      :count => params[:count] })
    }
  end

  private
  def load_user
    @user = User.find(params[:user_id])
  end
end
