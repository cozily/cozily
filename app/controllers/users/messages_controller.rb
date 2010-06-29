class Users::MessagesController < ApplicationController
  before_filter :load_user

  def index

  end

  def show
    @message = @user.messages.find(params[:id])
  end

  private
  def load_user
    @user = User.find(params[:user_id])
  end
end