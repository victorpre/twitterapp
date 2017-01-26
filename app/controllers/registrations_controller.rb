class RegistrationsController < Devise::RegistrationsController

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def account_update_params
    params.require(:user).permit(:name, :email,:phone_number,:address,:city, :state, :country, :password, :password_confirmation)
  end
end
