require 'test_helper'

class TweetsControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get tweets_search_url
    assert_response :success
  end

end
