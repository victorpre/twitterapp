require 'rails_helper'
require 'omniauth_helper'

RSpec.describe User, type: :model do
  before (:each) do
    users = User.all
    users.delete_all
  end
  it "should be created by oauth" do
    auth = OpenStruct.new set_omniauth
    user = User.find_for_twitter_oauth(auth)
    expect(user).to be_valid
  end

  it "should find user" do
    auth = OpenStruct.new set_omniauth
    user1 = User.find_for_twitter_oauth(auth)
    user2 = User.find_for_twitter_oauth(auth)
    expect(user1).to eq(user2)
  end
end
