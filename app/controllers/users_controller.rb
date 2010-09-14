class UsersController < Clearance::UsersController
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
    params[:user].merge!(:roles => params[:role_ids].map { |id| Role.find(id) }) if params[:role_ids].present?
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Welcome to Cozily!"
      redirect_to(url_after_create)
    else
      render :template => 'users/new'
    end
  end

  def update
    params[:user].merge!(:roles => params[:role_ids].map { |id| Role.find(id) }) if params[:role_ids].present?
    if @user.update_attributes(params[:user])
      redirect_to params[:return_to] || edit_user_path(@user)
    else
      render params[:return_to].present? ? 'users/profiles/edit' : 'edit'
    end
  end
end
