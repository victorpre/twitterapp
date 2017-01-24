class TweetsController < ApplicationController
  def search

  end

  def index
    tweet_params
    TwitterQuery.do(tweet_params.to_h)
  end

  private
  def tweet_params
    accessible = [:q, :positive, :negative, :since, :until, :location]
    params.permit(accessible)
  end
end
