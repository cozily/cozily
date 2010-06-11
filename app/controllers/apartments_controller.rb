class ApartmentsController < ApplicationController
  load_and_authorize_resource

  def index
    raise CanCan::AccessDenied unless current_user == User.find(params[:user_id])
    @apartments = current_user.apartments
  end

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
      redirect_to params[:return_to] || @apartment
    else
      render :edit
    end
  end

  def destroy
    @apartment = Apartment.find(params[:id])
    @apartment.destroy
    redirect_to params[:return_to] || root_path
  end

  def transition
    @apartment = Apartment.find(params[:id])
    @apartment.send("#{params[:event]}!")
    redirect_to params[:return_to] || @apartment
  end
end
