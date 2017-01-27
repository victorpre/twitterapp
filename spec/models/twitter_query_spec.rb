require 'rails_helper'

RSpec.describe TwitterQuery, type: :model do

  it "removes offensive words" do
    offensive_words = TwitterQuery::OFFENSIVE_WORDS_DICT.take(3)
    tweet_text = Faker::Lorem.paragraph(2)
    tweet_text+="#{offensive_words[0] }"
    tweet_text.insert(rand(0..tweet_text.length),offensive_words[1])
    tweet_text+=" #{offensive_words[2]}"
    expect(TwitterQuery.clean_tweet(tweet_text).split(" ")).not_to include(offensive_words)
  end
end
