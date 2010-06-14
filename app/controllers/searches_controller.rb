class SearchesController < ApplicationController
  def new
    @search = Search.new
  end

  def create
    @search = Search.new(params[:search])
  end
end