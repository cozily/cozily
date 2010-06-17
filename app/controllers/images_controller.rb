class ImagesController < ApplicationController
  def create
    image = Image.create(:asset => params[:userfile])
    render :text => "#{image.id},#{image.asset.url(:thumb)}"
  end
end