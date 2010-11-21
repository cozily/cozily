class SessionsController < Clearance::SessionsController
  def create
    @user = ::User.authenticate(params[:session][:email],
                                params[:session][:password])
    if @user.nil?
      flash_failure_after_create
      render :template => 'sessions/new', :status => :unauthorized
    else
      sign_in(@user)
      flash_success_after_create
      redirect_back_or(dashboard_path)
    end
  end
end