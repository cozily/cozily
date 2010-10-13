class Admin::UsersController < Admin::BaseController
  def index
    @users = User.all(:order => "first_name")
  end

  def show
    @user = User.find(params[:id])
  end

  def activity
    a = UserActivity.first(:order => "date").date
    b = UserActivity.last(:order => "date").date

    @activities = (a..b).map do |date|
      [date, UserActivity.count(:conditions => {:date => date})]
    end
  end
end