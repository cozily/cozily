class SignupController < ApplicationController
  def profile
    session[:want] = params[:want]
    @user = User.new
    render :json => { :want => render_to_string(:partial => "signup/profile") }
  end

  def account
    if params.has_key?(:profile)
      session[:profile] = params[:profile]
      @user = User.new
      render :json => { :account => render_to_string(:partial => "signup/account") }
    else
      session[:user] = params[:user]
      @user = User.new(params[:user].merge(:roles => [Role.find_by_name("lister")]))
      @user.valid?
      if @user.errors.any? { |attr, msg| attr == "email" || attr == "phone" }
        @errors = @user.errors.dup
        @user.errors.clear
        @errors.each do |attr, msg|
          @user.errors.add(attr, msg) if attr == "email" || attr == "phone"
        end
        render :json => { :want => render_to_string(:partial => "signup/profile") }
      else
        @user = User.new
        render :json => { :account => render_to_string(:partial => "signup/account") }
      end
    end
  end

  def create
    params[:user].merge!(session[:user]) if session[:user]
    @user = User.new(params[:user].merge(:roles => [Role.find_by_name(session[:want])]))
    if @user.save
      @user.create_profile(session[:profile])
      sign_in(@user)
      redirect_to dashboard_path
    else
      render "_account"
    end
  end
end