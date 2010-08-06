class SignupController < ApplicationController
  def profile
    session[:want] = params[:want]
    render :json => { :want => render_to_string(:partial => "signup/profile") }
  end

  def account
    session[:profile] = {}
    session[:profile] = params[:profile]
    @user = User.new
    render :json => { :account => render_to_string(:partial => "signup/account") }
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @user.create_profile(session[:profile])
      sign_in(@user)
      redirect_to dashboard_matches_path
    else
      render "_account"
    end
  end
end