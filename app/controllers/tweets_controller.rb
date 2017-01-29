class TweetsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    tweet_params_hash = TwitterQuery.clean_params(tweet_params.to_h)
    @tweets = []
    begin
      @tweets = TwitterQuery.do(tweet_params_hash)
    rescue Exception => ex
      flash[:error] = ex.message
    end
  end

  private
  def tweet_params
    accessible = [:q, :location, :since, :until, :attitude]
    params.require(:query).permit(accessible)
  end
end
