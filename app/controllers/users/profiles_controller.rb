class Users::ProfilesController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @user = current_user
    @user.create_profile if @user.profile.nil?
    respond_to do |format|
      format.html {}
      format.js do
        render :json => { :form => render_to_string(:partial => "users/profiles/edit") }
      end
    end
  end

  def update
    @user = current_user
    @user.create_profile if @user.profile.nil?
    params[:user].merge!(:role_ids => params[:role_ids]) if params[:assign_roles]
    if @user.update_attributes(params[:user])
      @user.profile.neighborhood_profiles.destroy_all if params[:return_to].present? && !params[:user][:profile_attributes][:neighborhood_ids].present?
      redirect_to params[:return_to] || edit_user_path(@user)
    else
      render params[:return_to].present? ? 'users/profiles/edit' : 'edit'
    end
  end
end
