class TwitterQuery
  OFFENSIVE_WORDS_DICT = ["ass", "bitch", "cunt", "fuck","fucker", "motherfucker", "nigger", "asshole"]

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
                 "place"       => (get_map_url(tweet, client) unless tweet.place.nil?),
                 "text"        => clean_tweet(tweet.full_text) }
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

  def self.clean_tweet(tweet)
    safe_tweet = tweet.dup
    offensive_words = safe_tweet.downcase.split(" ") & OFFENSIVE_WORDS_DICT
    offensive_words.each do |word|
      safe_tweet.gsub!(word,"*"*word.size)
    end
    safe_tweet
  end

  def self.prepare_query(hashtag, attitude)
    # TODO check for >1 hashtags
    prepared_hashtag = hashtag[0]=="#"? hashtag : "##{hashtag}"
    prepared_hashtag += " #{attitude}" if attitude
    prepared_hashtag
  end

  def self.get_map_url(tweet, client)
    coords = get_map_location(tweet,client)
    url = "https://maps.googleapis.com/maps/api/staticmap?center=#{coords['lat']},#{coords['lng']}"+
    "&zoom=11&size=400x400&markers=color:red|#{coords['lat']},#{coords['lng']}"
    img_tag = "<img src=\"#{url}\">"
  end

  def self.get_map_location(tweet, client)
    place_id = tweet.place.id
    coords_arr = client.place(place_id).attrs[:centroid]
    coords = {}
    coords["lat"] = coords_arr[0]
    coords["lng"] = coords_arr[1]
    coords
  end
end
