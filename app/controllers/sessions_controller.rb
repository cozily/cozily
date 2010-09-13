class SessionsController < Clearance::SessionsController
  def create
    @user = ::User.authenticate(params[:session][:email],
                                params[:session][:password])
    if @user.nil?
      flash_failure_after_create
      render :template => 'sessions/new', :status => :unauthorized
    else
      sign_in(@user)
      redirect_back_or(url_after_create)
      if @user.email_confirmed?
        flash_success_after_create
      else
        flash[:notice] = "Remember to confirm your email address."
      end
    end
  end
end