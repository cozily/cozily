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

  def update
    if @user.update_attributes(params[:user])
      @user.user_roles.destroy_all
      (params[:role_ids] || []).each do |role_id|
        @user.roles << Role.find(role_id)
      end
      redirect_to edit_user_path(@user)
    else
      render 'edit'
    end
  end
end
