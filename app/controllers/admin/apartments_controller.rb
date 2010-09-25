class Admin::ApartmentsController < Admin::BaseController
  def index
    @apartments = Apartment.all(:order => "created_at")
  end
end