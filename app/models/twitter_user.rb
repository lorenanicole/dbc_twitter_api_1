require 'pry'

class TwitterUser < ActiveRecord::Base
  has_many :tweets

  def fetch_tweets!
    tweets_array = $client.user_timeline(self.username, :count => 10)
    tweets_array.each do |tweet|
      Tweet.create(body: tweet.text, twitter_user_id: self.id)
    end
  end

  def tweets_stale?
    time_diff = Time.now.utc.to_i - self.tweets.all.last.created_at.to_i
    if time_diff >= 60
      self.tweets.destroy_all
      self.fetch_tweets!
    end
  end

end
