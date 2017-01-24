class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]

  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && !current_user.email_previously_changed?
      redirect_to finish_signup_path(current_user)
    end
  end
end
