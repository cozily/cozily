class WelcomeController < ApplicationController
  def index
    redirect_to dashboard_matches_path if signed_in?
  end
end