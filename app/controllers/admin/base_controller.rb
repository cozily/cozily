class Admin::BaseController < ApplicationController
  before_filter :authenticate, :ensure_admin

  def index
  end

  private
  def ensure_admin
    raise CanCan::AccessDenied unless current_user.admin?
  end
end