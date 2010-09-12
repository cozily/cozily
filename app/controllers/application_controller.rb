require 'geokit-rails'

class ApplicationController < ActionController::Base
  include Clearance::Authentication
  helper :all
  protect_from_forgery

  geocode_ip_address

  before_filter :load_search

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  def render_optional_error_file(status_code)
    if status_code == :not_found
      render_404
    elsif status_code == :internal_server_error
      render_500
    else
      super
    end
  end

  def render_404
    respond_to do |type|
      type.html {
        render :template => "errors/404", :layout => 'application', :status => 404
      }
      type.all { render :nothing => true, :status => 404 }
    end
    true
  end

  def render_500
    respond_to do |type|
      type.html {
        render :template => "errors/500", :layout => 'application', :status => 500
      }
      type.all { render :nothing => true, :status => 500 }
    end
    true
  end

  def load_search
    @search = Search.new(:neighborhood_ids => session[:neighborhood_ids],
                         :min_bedrooms => session[:min_bedrooms],
                         :max_rent => session[:max_rent],
                         :page => params[:page])
  end
end
