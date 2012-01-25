class RegistrationsController < Devise::RegistrationsController
  def edit
    respond_to do |format|
      format.html do
        render "users/registrations/edit"
      end
      format.js do
        render :json => { :form => render_to_string(:partial => "users/registrations/edit") }
      end
    end
  end

  def create
    params[:user].merge!(:role_ids => params[:role_ids]) if params[:assign_roles]
    @user = User.new(params[:user])
    if @user.save
      sign_in(@user)
      flash[:notice] = "Welcome to Cozily!"
      redirect_to dashboard_path
    else
      render :template => 'users/registrations/new'
    end
  end

  def update
    params[:user].merge!(:role_ids => params[:role_ids]) if params[:assign_roles]
    if @user.update_attributes(params[:user])
      @user.profile.neighborhood_profiles.destroy_all if params[:return_to].present? && !params[:user][:profile_attributes][:neighborhood_ids].present?
      redirect_to params[:return_to] || edit_user_registration_path
    else
      render params[:return_to].present? ? 'users/profiles/edit' : 'users/registrations/edit'
    end
  end
end
