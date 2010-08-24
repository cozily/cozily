class ApartmentsController < ApplicationController
  load_and_authorize_resource

  def index
    raise CanCan::AccessDenied unless current_user == User.find(params[:user_id])
    @apartments = current_user.apartments
  end

  def show
    @apartment = Apartment.find(params[:id])
    @apartment.update_attribute(:views_count, @apartment.views_count + 1) if current_user != @apartment.user
  end

  def edit
    @apartment = Apartment.find(params[:id])
  end

  def create
    @apartment = current_user.apartments.create!
    redirect_to edit_apartment_path(@apartment)
  end

  def update
    @apartment = Apartment.find(params[:id])
    if @apartment.update_attributes(params[:apartment])
      respond_to do |format|
        format.html { redirect_to params[:return_to] || edit_apartment_path(@apartment) }
        format.js do
          render :json => {
                  :comparables => render_to_string(:partial => "apartments/comparables",
                                                   :locals => { :apartments => @apartment.comparable_apartments })
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

  def order_images
    @apartment = Apartment.find(params[:id])
    images = @apartment.images
    images.each do |image|
      image.position = params['image'].index(image.id.to_s) + 1
      image.save
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
