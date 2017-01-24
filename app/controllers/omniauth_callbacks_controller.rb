class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter
    auth = env["omniauth.auth"]

    @user = User.find_for_twitter_oauth(request.env["omniauth.auth"],current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.twitter_uid"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def after_sign_in_path_for(resource)
    if resource.has_complete_profile?
      root_path
    else
      finish_signup_path(resource)
    end
  end
end
