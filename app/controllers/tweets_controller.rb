class TweetsController < ApplicationController
  def search

  end

  def index
    tweet_params
    @tweets = TwitterQuery.do(tweet_params.to_h)
  end

  private
  def tweet_params
    accessible = [:q, :positive, :negative, :since, :until, :location]
    params.require(:query).permit(accessible)
  end
end
