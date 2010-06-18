class ImagesController < ApplicationController
  before_filter :load_apartment

  def create
    @image = @apartment.images.create(:asset => params[:userfile])

    # TODO : Make this work with JSON
    render :text => render_to_string(:partial => "images/thumbnail", :locals => { :image => @image })
  end

  def destroy
    @image = @apartment.images.find(params[:id])
    @image.destroy
    render :nothing => :true
  end

  private
  def load_apartment
    @apartment = Apartment.find(params[:apartment_id])
  end
end