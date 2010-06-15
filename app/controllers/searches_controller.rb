class SearchesController < ApplicationController
  def new
    @search = Search.new
  end

  def show
    @search = Search.new(params[:search])
  end
end