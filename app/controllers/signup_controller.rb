class SignupController < ApplicationController
  def profile
    session[:want] = params[:want]
    @user = User.new
    render :json => { :want => render_to_string(:partial => "signup/profile") }
  end

  def account
    session[:user] = params[:user]
    if session[:want] == "finder"
      @user = User.new
      render :json => { :account => render_to_string(:partial => "signup/account") }
    else
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
    redirect_to root_url and return unless params[:user].present?

    params[:user].merge!(session[:user])
    @user = User.new(params[:user].merge(:roles => [Role.find_by_name(session[:want])]))
    if @user.save
      sign_in(@user)
      flash[:notice] = "Welcome to Cozily!"
      redirect_to dashboard_path
    else
      render "_account"
    end
  end
end
