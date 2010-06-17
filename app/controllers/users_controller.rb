class UsersController < Clearance::UsersController
  load_and_authorize_resource

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to root_path
    else
      render 'edit'
    end
  end
end
