class TwitterQuery
  def self.do(args = {})
    client = TwitterClientFactory.new.client

    hashtag = args.delete "q"
    attitude = args.delete "attitude" if args["attitude"]

    query = prepare_query(hashtag, attitude)
    filters = prepare_filters(args)

    payload = client.search(query, filters)
    tweets = []
    payload.each do |tweet|
      tweets << {"screen_name" => tweet.user.screen_name,
                 "created_at"  => tweet.created_at.to_date.strftime("%a, %d %b %Y"),
                 "name"        => tweet.user.name,
                 "profile_image_url"=> tweet.user.profile_image_url.to_s.gsub("_normal",""),
                 "text"        => tweet.full_text }
    end
    tweets
  end

  def self.prepare_filters(params)
    filters = {}
    filters["result_type"] = "recent"
    if params["location"]
      filters["geocode"] = get_location_coordinates(params["location"])
    end

    if params["since"]
      filters["since"] = parse_date(params["since"])
    end

    if params["until"]
      filters["until"] = parse_date(params["until"])
    end
    filters
  end

  def self.get_location_coordinates(location)
    coord = Geocoder.search(location)
    if !coord.empty?
      coord = coord.first.data["geometry"]["location"]
      coord.values.join(",")+",6km"
    else
      nil
    end
  end

  def self.clean_params(args)
    args.delete_if{|k,v| v.empty?}
  end

  def self.parse_date(date)
    begin
      date = Date.parse(date)
    rescue ArgumentError
      date = nil
    else
      date.strftime("%F")
    end
  end

  def self.clean_tweets()

  end

  def self.prepare_tweets_html(tweets)

  end

  def self.prepare_query(hashtag, attitude)
    prepared_hashtag = hashtag[0]=="#"? hashtag : "##{hashtag}"
    prepared_hashtag += " #{attitude}" if attitude
    prepared_hashtag
  end
end
