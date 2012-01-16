class PhotosController < ApplicationController
  before_filter :load_apartment

  def create
    raise params[:userfile].inspect
    @image = @apartment.photos.create(:image => params[:userfile])

    render :text => render_to_string(:partial => "apartments/photo", :locals => { :apartment => @apartment })
  end

  def destroy
    @image = @apartment.photos.find(params[:id])
    @image.destroy
    render :json => {:photos              => render_to_string(:partial => "apartments/photos",
                                                              :locals  => {:apartment => @apartment}),
                     :owner_buttons       => render_to_string(:partial => "apartments/owner_buttons",
                                                              :locals  => {:apartment => @apartment}),
                     :missing_information => render_to_string(:partial => "apartments/missing_information",
                                                              :locals  => {:apartment => @apartment})
    }
  end

  private
  def load_apartment
    @apartment = Apartment.find(params[:apartment_id])
  end
end
