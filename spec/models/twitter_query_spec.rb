require 'rails_helper'

RSpec.describe TwitterQuery, type: :model do

  it "removes offensive words" do
    offensive_words = TwitterQuery::OFFENSIVE_WORDS_DICT.take(3)
    tweet_text = Faker::Lorem.paragraph(2)
    offensive_words.each do |word|
      tweet_text.insert(rand(0..tweet_text.length),word)
    end
    tweet_text+=" #{offensive_words[1]}"
    expect(TwitterQuery.clean_tweet(tweet_text).split(" ")).not_to include(offensive_words)
  end
end
