class Admin::UsersController < ApplicationController
  before_filter :authenticate

  def index
    @users = User.all
  end
end