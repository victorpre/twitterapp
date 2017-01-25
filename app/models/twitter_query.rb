class TwitterQuery
  def self.do(args = {})
    client = TwitterClientFactory.new.client
    hashtag = args["q"]
    hashtag = "##{hashtag}" unless hashtag[0]=="#"
    payload = client.search(hashtag, result_type: "recent").take(10)
    tweets = []
    payload.each do |tweet|
      tweets << {"screen_name" => tweet.user.screen_name,
                 "name"        => tweet.user.name,
                 "text"        => tweet.text }
    end
    tweets
  end
end
