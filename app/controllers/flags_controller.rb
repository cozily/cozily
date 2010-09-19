class FlagsController < ApplicationController
  before_filter :load_user

  def create
    @flag = @user.flags.create(params[:flag])
    authorize! :create, @flag

    render :json => { :flag_link => render_to_string(:partial => "flags/link",
                                                     :locals => { :apartment => @flag.apartment }) }
  end

  def destroy
    @flag = @user.flags.find(params[:id])
    authorize! :destroy, @flag

    @flag.destroy
    render :json => { :flag_link => render_to_string(:partial => "flags/link",
                                                     :locals => { :apartment => @flag.apartment }) }
  end

  private
  def load_user
    @user = User.find(params[:user_id])
  end
end