require 'rails_helper'

RSpec.describe TwitterQuery, type: :model do

  it "should remove offensive words" do
    offensive_words = TwitterQuery::OFFENSIVE_WORDS_DICT.take(3)
    tweet_text = Faker::Lorem.paragraph(2)
    tweet_text+="#{offensive_words[0] }"
    tweet_text.insert(rand(0..tweet_text.length),offensive_words[1])
    tweet_text+=" #{offensive_words[2]}"
    expect(TwitterQuery.clean_tweet(tweet_text).split(" ")).not_to include(offensive_words)
  end

  it "should get coordinates for a valid location" do
    expect(TwitterQuery.get_location_coordinates("Lugar-nenhum12345")).to be_nil
    expect(TwitterQuery.get_location_coordinates("São paulo")).to match(/^(\-?\d+(\.\d+)?),\s*(\-?\d+(\.\d+)?),6km$/)
  end

  it "should not have empty filter values" do
    filter_params = {"empty":""}
    expect(TwitterQuery.clean_params(filter_params)).to match({})
  end

  it "should parse date to YYYY-MM-DD String format" do
    date = "10/10/2010"
    expect(TwitterQuery.parse_date(date)).to match(/^[0-9]{4}-[0-9]{2}-[0-9]{2}$/)

    not_a_date = "1234"
    expect(TwitterQuery.parse_date(not_a_date)).to be_nil
  end

  it "should add url to hashtag" do
    tweet_text = "#hashtag"
    expect(TwitterQuery.set_hashtags_urls(tweet_text)).to start_with("<a href='tweets?query[q]=")

    not_a_hashtag = "hashtag"
    expect(TwitterQuery.set_hashtags_urls(not_a_hashtag)).to eq not_a_hashtag
  end

  it "should set filters to Twitter API" do
    params = {"location" => "Rio de Janeiro",
              "since"    => "11/10/2010"}

    expect(TwitterQuery.prepare_filters(params)).to include("geocode" => a_string_matching(/^(\-?\d+(\.\d+)?),\s*(\-?\d+(\.\d+)?),6km$/))
    expect(TwitterQuery.prepare_filters(params)).to include("since" => "2010-10-11")
    expect(TwitterQuery.prepare_filters(params)).to include("result_type" => "recent")
    expect(TwitterQuery.prepare_filters(params)).not_to include("until")
  end

  it "should preare query for Twitter API " do
    query = "#hashtag"
    not_a_hashtag = "hashtag"
    multiple_hashtags = "#hashtag hashtag"
    wrong_hashtag = "#!wrong"

    expect(TwitterQuery.prepare_query(query)).to eq(query)
    expect(TwitterQuery.prepare_query(not_a_hashtag)).to eq("##{not_a_hashtag}")
    expect(TwitterQuery.prepare_query(multiple_hashtags)).to eq("#hashtag #hashtag")
    expect(TwitterQuery.prepare_query(wrong_hashtag)).to eq("")
  end

  it "should wrap wrong queries" do
    args = {
      "q"=>"$wrong"
    }
    expect{TwitterQuery.do(args)}.to raise_error("That was not a valid hashtag.")
  end
end
