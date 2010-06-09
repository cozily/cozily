class ApplicationController < ActionController::Base
  include Clearance::Authentication
  helper :all
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end
end
