class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def passthru
    # render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    raise ActionController::RoutingError.new('Not Found')
  end

  def facebook
    if user_signed_in?
      current_user.add_additional_oauth(env["omniauth.auth"])
      redirect_to browse_path
    else
      @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end
  end
end
