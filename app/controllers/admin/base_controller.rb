class Admin::BaseController < ApplicationController
  before_filter :authenticate, :ensure_admin

  private
  def ensure_admin
    raise CanCan::AccessDenied unless current_user.admin?    
  end
end