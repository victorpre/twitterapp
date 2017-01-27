class TwitterQuery
  OFFENSIVE_WORDS_DICT = ["ass", "bitch", "cunt", "fuck","fucker", "motherfucker", "nigger", "asshole"]
  HASHTAG_REGEX = /\B(\#[a-zA-Z]+\b)(?!;)/

  def self.do(args = {})
    client = TwitterClientFactory.new.client

    hashtags = args.delete "q"
    attitude = args.delete "attitude" if args["attitude"]

    query = prepare_query(hashtags, attitude)
    filters = prepare_filters(args)

    payload = client.search(query, filters)
    tweets = []
    payload.take(50).each do |tweet|
      tweets << {"screen_name" => tweet.user.screen_name,
                 "created_at"  => tweet.created_at.to_date.strftime("%a, %d %b %Y"),
                 "name"        => tweet.user.name,
                 "profile_image_url"=> tweet.user.profile_image_url.to_s.gsub("_normal",""),
                 "map_iframe"       => (get_map_url(tweet, client).html_safe unless tweet.place.nil?),
                 "text"        => set_hashtags_urls(tweet.full_text) }
    end
    tweets
  end

  def self.prepare_filters(params)
    filters = {}
    if params["location"]
      filters["geocode"] = get_location_coordinates(params["location"])
    end

    if params["since"]
      filters["since"] = parse_date(params["since"])
    end

    if params["until"]
      filters["until"] = parse_date(params["until"])
    end
    filters["result_type"] = "recent"
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

  def self.set_hashtags_urls(tweet)
    sanitized_tweet = clean_tweet(tweet)
    sanitized_tweet.gsub(HASHTAG_REGEX){|hashtag|
      "<a href='tweets?query[q]=#{hashtag[1..-1]}'>#{hashtag}</a>"
    }
  end

  def self.prepare_query(query, attitude)
    terms = []
    query.split(" ").each do |hashtag|
      terms << (hashtag[0]=="#"? hashtag : "##{hashtag}")
    end
    prepared_hashtag = terms.join(" ")
    prepared_hashtag += " #{attitude}" if attitude
    prepared_hashtag
  end

  def self.get_map_url(tweet, client)
    coords = get_map_location(tweet,client)
    url="https://www.google.com/maps/embed/v1/place?q=#{coords['lat']},#{coords['lng']}&key=AIzaSyDQMZd5Exf1zChPkMHTpZJrYhe-P23H23k"
    iframe_tag = '<iframe width="100%" height="200" frameborder="0" style="border:0" src="'+url+'" allowfullscreen></iframe>'
  end

  def self.get_map_location(tweet, client)
    place_id = tweet.place.id
    coords_arr = client.place(place_id).attrs[:centroid]
    coords = {}
    coords["lng"] = coords_arr[0]
    coords["lat"] = coords_arr[1]
    coords
  end
end
