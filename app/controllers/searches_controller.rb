class SearchesController < ApplicationController
  def show
    @search = params[:q].present? ? Search.new(params[:q]) : Search.new
  end
end