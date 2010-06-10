class ApartmentsController < ApplicationController
  load_and_authorize_resource

  def new
    @apartment = Apartment.new
    @apartment.build_address
  end

  def show
    @apartment = Apartment.find(params[:id])
  end

  def edit
    @apartment = Apartment.find(params[:id])
  end

  def create
    @apartment = current_user.apartments.new(params[:apartment])
    if @apartment.save
      redirect_to @apartment
    else
      render :new
    end
  end

  def update
    @apartment = Apartment.find(params[:id])
    if @apartment.update_attributes(params[:apartment])
      redirect_to @apartment
    else
      render :edit
    end
  end

  def destroy
    @apartment = Apartment.find(params[:id])
    @apartment.destroy
    redirect_to root_path
  end
end
