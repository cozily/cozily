class WelcomeController < ApplicationController
  def index
    if signed_in?
      redirect_to dashboard_path
    else
      render "unauthenticated"
    end
  end
end