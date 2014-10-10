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

tweets = client.get_all_tweets("ubc_founder")

tweets.each do |tweet|
    puts tweet.text
end
