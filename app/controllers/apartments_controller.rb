class ApartmentsController < ApplicationController
  def new
    @apartment = Apartment.new
    @apartment.build_address
  end

  def show
    @apartment = Apartment.find(params[:id])
  end

  def create
    @apartment = Apartment.new(params[:apartment])
    if @apartment.save
      redirect_to @apartment
    else
      render :new
    end
  end
end