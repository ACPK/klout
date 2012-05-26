require 'klout'
require 'json'

module Klout
  # Represents an identity
  
  class Identity
    class << self
      def find_by_twitter_id(twitter_id)
        response = Klout.get "/identity.json/tw/#{twitter_id}", :query => {key: Klout.api_key}
        Hashie::Mash.new(response)
      end
      
      def find_by_twitter_screen_name(screen_name)
        response = Klout.get "/identity.json/twitter", :query => {key: Klout.api_key, screenName: screen_name}
        Hashie::Mash.new(response)
      end
      
      def find_by_klout_id(klout_id)
        response = Klout.get "/identity.json/klout/#{klout_id}/tw", :query => {key: Klout.api_key}
        Hashie::Mash.new(response)
      end
    end
  end
end