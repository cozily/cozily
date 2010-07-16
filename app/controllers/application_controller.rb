require 'geokit-rails'
require 'mobile_fu'

class ApplicationController < ActionController::Base
  include Clearance::Authentication
  helper :all
  protect_from_forgery

  geocode_ip_address
  has_mobile_fu

  layout :set_layout

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  private
  def set_layout
    if is_mobile_device?
      "mobile"
    else
      "application"
    end
  end
end
