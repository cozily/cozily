class ErrorsController < ApplicationController
  def routing
    e = Exception.new("Unable to find route: #{params[:route]}")
    render_not_found(e)
  end
end