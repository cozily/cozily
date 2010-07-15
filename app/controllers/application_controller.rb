require 'geokit-rails'

class ApplicationController < ActionController::Base
  include Clearance::Authentication
  helper :all
  protect_from_forgery

  geocode_ip_address
  has_mobile_fu

  before_filter :check_mobile

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  private
  def check_mobile
    render :text => "mobile version coming soon" if is_mobile_device?
  end
end
