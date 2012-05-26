require 'klout'
require 'json'

module Klout
  # Represents a user
  
  class User
    attr_reader :klout_id
    
    def initialize(klout_id)
      @klout_id = klout_id
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
      Hashie::Mash.new(response)
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
      "/user.json/#{klout_id}#{action}"
    end
  end
end