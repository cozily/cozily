class SignupController < ApplicationController
  def profile
    session[:want] = params[:want]
    render :json => { :want => render_to_string(:partial => "signup/profile") }
  end

  def account
    session[:profile] = params[:profile] if params.has_key?(:profile)
    session[:user] = params[:user] if params.has_key?(:user)
    @user = User.new
    render :json => { :account => render_to_string(:partial => "signup/account") }
  end

  def create
    params[:user].merge!(session[:user]) if session[:user]
    @user = User.new(params[:user])
    if @user.save
      @user.roles << Role.find_by_name(session[:want])
      @user.create_profile(session[:profile])
      sign_in(@user)
      redirect_to dashboard_path
    else
      render "_account"
    end
  end
end