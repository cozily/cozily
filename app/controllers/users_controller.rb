class UsersController < Clearance::UsersController
  load_and_authorize_resource

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      @user.user_roles.destroy_all
      (params[:role_ids] || []).each do |role_id|
        @user.roles << Role.find(role_id)
      end
      redirect_to root_path
    else
      render 'edit'
    end
  end
end
