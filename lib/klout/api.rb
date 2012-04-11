module Klout
  class API
    include HTTParty
    format :plain
    default_timeout 30
    
    attr_accessor :api_key, :timeout
    
    # == Usage
    #
    # Initialize with your Klout API key:
    #
    # k = Klout::API.new('api-key')
    #
    # Or you can set the +ENV['KLOUT_API_KEY']+ environment variable:
    #
    # k = Klout::API.new
    #
    def initialize(api_key = nil)
      @api_key = api_key || ENV['KLOUT_API_KEY'] || raise(ArgumentError)
    end
    
    def base_api_url # :nodoc:
      "http://api.klout.com/v2"
    end
    
    # === Identity
    #
    # Use the +identity+ method to get a user's +klout_id+.
    # Pass either a numerical Twitter ID (Integer) or a Twitter screen name (String)
    #
    # k.identity(500042487)
    # k.identity('dhh')
    #
    # You can also select a different network:
    #
    # k.identity('dhh', :ks)
    #
    def identity(id, network = :tw)
      path = id.is_a?(Integer) ? "#{network}/#{id}?key=#{@api_key}" : "twitter?screenName=#{id}&key=#{@api_key}"
      call("/identity.json/#{path}")
    end
    
    # === User
    #
    # Use the +user+ method to get information about a user. Pass in a trait
    # option to get score, influence and topics data:
    #
    # k.user(635263)
    # k.user(635263, :influence)
    # k.user(635263, :score)
    # k.user(635263, :topics)
    #
    def user(id, trait = nil)
      lookup = trait.nil? ? '' : "/#{trait.to_s}"
      call("/user.json/#{id}#{lookup}?key=#{@api_key}")
    end
    
    protected
    
    def call(endpoint) # :nodoc:
      response = self.class.get(base_api_url + endpoint)
      response.code.to_i == 200 ? JSON.parse(response.body) : raise(API::Error.new("HTTP Response Code: #{response.code}"))
    end
    
    class Error < StandardError
    end
  end
end