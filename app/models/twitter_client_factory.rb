class TwitterClientFactory
  attr_accessor :client
  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key    = Rails.application.secrets.twitter_api_key
      config.consumer_secret = Rails.application.secrets.twitter_api_secret
    end
  end
end
