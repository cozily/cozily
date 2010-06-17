class ImagesController < ApplicationController
  def create
    @apartment = Apartment.find(params[:apartment_id])
    image = @apartment.images.create(:asset => params[:userfile])
    render :text => "#{image.id},#{image.asset.url(:thumb)}"
  end
end