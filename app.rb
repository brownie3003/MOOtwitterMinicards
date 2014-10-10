require 'sinatra'
require 'slim'
require 'twitter'

client = Twitter::REST::Client.new do |config|
    config.consumer_key        = "FmHICqBSh0VKKFzRqWtj41om7"
    config.consumer_secret     = "yeqEsrNnkCLUAYfhOwesX79WZc63ztaX9IoeEZPZtQboNj5rlK"
    config.access_token        = "37697270-h3RDw1tyNvAtfSMNru3SO3YoKlzYm2O7MbmfOMrQ1"
    config.access_token_secret = "E2O2cc3Q7aRIjL8OOKnFUPEXpnFodZ9iD91QALb4oWOUB"
end

def collect_with_max_id(collection=[], max_id=nil, &block)
    response = yield(max_id)
    collection += response
    response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
end

def client.get_all_tweets(user)
    collect_with_max_id do |max_id|
        options = {:count => 200, :include_rts => false}
        options[:max_id] = max_id unless max_id.nil?
        user_timeline(user, options)
    end
end

def hash_tags(tweets)
    hash_tags = {}
    tweets.each do |tweet|
        tweet.text.split(" ").each do |word|
            if word[0] == "#"
                hash_tag = word.gsub(/[^a-z0-9\s]/i, '')
                if hash_tags[hash_tag]
                    hash_tags[hash_tag] += 1
                else
                    hash_tags[hash_tag] = 1
                end
            end
        end
    end

    hash_tags = hash_tags.sort_by {|key, value| value}
    return hash_tags.reverse
end

get '/:name' do
    user = client.user(params[:name])
    profile = user.profile_image_url.to_s.gsub("normal", "bigger")
    tweets = client.get_all_tweets(params[:name])
    hash_tags = hash_tags(tweets)
    slim :index, locals: {user: user, profile: profile, tweets: tweets, hash_tags: hash_tags}
end

get '/styles.css' do
    scss :styles
end
