class Admin::UsersController < Admin::BaseController
  def index
    @users = User.all(:order => "first_name")
  end
end