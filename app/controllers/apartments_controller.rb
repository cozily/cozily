class ApartmentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  load_and_authorize_resource

  def new
    @apartment = current_user.apartments.create!
    redirect_to edit_apartment_path(@apartment)
  end

  def show
    @apartment = Apartment.find(params[:id])
    @nearby_stations = @apartment.nearby_stations

    if @apartment.published? && !@apartment.owned_by?(current_user)
      @apartment.increment(:views_count)
    end
  end

  def edit
    @apartment = Apartment.find(params[:id])
  end

  def update
    @apartment = Apartment.find(params[:id])
    params[:apartment][:rent].gsub!(/[^0-9]/, "")
    if @apartment.update_attributes(params[:apartment])
      if @apartment.address.try(:invalid?)
        flash[:failure] = "We're currently only accepting apartment listings in New York City."
      elsif @apartment.address.nil? && params[:apartment][:full_address].present?
        flash[:failure] = "We're looking for building level accuracy on the address.  No intersections, please."
      end
      respond_to do |format|
        format.html { redirect_to params[:return_to] || edit_apartment_path(@apartment) }
        format.js do
          render :json => {
              :owner_buttons       => render_to_string(:partial => "apartments/owner_buttons",
                                                       :locals  => {:apartment => @apartment}),
              :missing_information => render_to_string(:partial => "apartments/missing_information",
                                                       :locals  => {:apartment => @apartment})
          }
        end
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js { render :nothing => true }
      end
    end
  end

  def destroy
    @apartment = Apartment.find(params[:id])
    @apartment.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_listings_path }
      format.js { render :nothing => true }
    end
  end

  def order_photos
    @apartment = Apartment.find(params[:id])
    @apartment.photos.each do |photo|
      photo.position = params['photo'].index(photo.id.to_s) + 1
      photo.save
    end
    render :nothing => true
  end

  def transition
    @apartment = Apartment.find(params[:id])
    @apartment.send("#{params[:event]}!")
    respond_to do |format|
      format.html do
        redirect_to params[:return_to] || edit_apartment_path(@apartment)
      end
      format.js do
        render :json => { :state_buttons => render_to_string(:partial => "apartments/state_buttons",
                                                             :locals => { :apartment => @apartment }) }
      end
    end
  end
end
