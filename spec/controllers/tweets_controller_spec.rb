require 'rails_helper'
OmniAuth.config.test_mode = true

RSpec.describe TweetsController, type: :controller do
   describe "GET #index" do
     subject { get :index, params:{ :query => {:q => "$dddo"}}}

     it "should redirect to login page when not authenticated" do
      expect(subject).to redirect_to(new_user_session_url)
      expect(response).to have_http_status(302)
     end
   end
end
