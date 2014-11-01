require 'klout'
require 'json'

module Klout
  # Represents a user
  class TwUser
    attr_reader :twitter_id
    
    def initialize(twitter_id)
      @twitter_id = twitter_id
    end
    
    def details
      response = get
      Hashie::Mash.new(response)
    end
    
    def score
      response = get "score"
      Hashie::Mash.new(response)
    end
    
    def topics
      response = get "topics"
      response.parsed_response
    end
    
    def influence
      response = get "influence"
      Hashie::Mash.new(response)
    end
    
    private
    
    def get(action = nil)
      Klout.get uri_for(action), :query => {key: Klout.api_key}
    end
    
    def uri_for(action = nil)
      action = "/#{action}" if action
      "/tw-user.json/#{twitter_id}#{action}"
    end
  end
end