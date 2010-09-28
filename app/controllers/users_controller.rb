class UsersController < Clearance::UsersController
  before_filter :authenticate, :except => [ :create ]
  load_and_authorize_resource

  def edit
    respond_to do |format|
      format.html {}
      format.js do
        render :json => { :form => render_to_string(:partial => "users/edit") }
      end
    end
  end

  def create
    params[:user].merge!(:roles => (params[:role_ids] || []).map { |id| Role.find(id) }) if params[:assign_roles]
    @user = User.new(params[:user])
    if @user.save
      sign_in(@user)
      flash[:notice] = "Welcome to Cozily!"
      redirect_to dashboard_path
    else
      render :template => 'users/new'
    end
  end

  def update
    params[:user].merge!(:roles => (params[:role_ids] || []).map { |id| Role.find(id) }) if params[:assign_roles]
    if @user.update_attributes(params[:user])
      @user.profile.neighborhood_profiles.destroy_all if params[:return_to].present? && !params[:user][:profile_attributes][:neighborhood_ids].present?
      redirect_to params[:return_to] || edit_user_path(@user)
    else
      render params[:return_to].present? ? 'users/profiles/edit' : 'edit'
    end
  end
end
