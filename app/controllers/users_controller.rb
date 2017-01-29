class UsersController < ApplicationController
before_action :set_user

 def finish_signup
   @form_fields = current_user.missing_attributes
   @user = current_user
   if request.patch? && params[:user]
     if @user.update(user_params)
       sign_in(@user, :bypass => true)
       redirect_to root_url, notice: 'Your profile was successfully updated.'
     else
       @show_errors = true
     end
   end
 end

 private
   def set_user
     @user = User.find(params[:id])
   end

   def user_params
     accessible = current_user.missing_attributes
     params.require(:user).permit(accessible)
   end
 end
