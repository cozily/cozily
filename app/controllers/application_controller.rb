require 'geokit-rails'

class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery

  geocode_ip_address

  before_filter :perform_basic_authentication_on_staging
  before_filter :load_search
  before_filter :save_user_activity

  rescue_from CanCan::AccessDenied do |exception|
    flash[:failure] = exception.message
    redirect_to root_url
  end

  rescue_from FriendlyId::BlankError do
    flash[:failure] = "The apartment needs an address."
    redirect_to :back
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception,                            :with => :render_error
    rescue_from ActiveRecord::RecordNotFound,         :with => :render_not_found
    rescue_from ActionController::UnknownController,  :with => :render_not_found
    rescue_from ActionController::UnknownAction,      :with => :render_not_found
  end

  def render_not_found(e)
    Exceptional.handle(e)
    respond_to do |type|
      type.html {
        render :template => "errors/404", :layout => 'error', :status => 404
      }
      type.all { render :nothing => true, :status => 404 }
    end
    true
  end

  def render_error(e)
    Exceptional.handle(e)
    respond_to do |type|
      type.html {
        render :template => "errors/500", :layout => 'error', :status => 500
      }
      type.all { render :nothing => true, :status => 500 }
    end
    true
  end

  def perform_basic_authentication_on_staging
    if Rails.env.staging?
      authenticate_or_request_with_http_basic do |username, password|
        username == "cozily" && password == "marathon69"
      end
    end
  end

  def load_search
    @search = Search.new(:neighborhood_id => session[:neighborhood_id],
                         :min_bedrooms => session[:min_bedrooms],
                         :max_rent => session[:max_rent],
                         :page => params[:page])
  end

  def save_user_activity
    return if !user_signed_in? || current_user.has_activity_today?
    current_user.activities.create(:date => Date.today)
  end

  def unauthenticate
    if current_user
      redirect_to destroy_user_session
      return false
    end
  end
end
