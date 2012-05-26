require 'cgi'
require 'uri'
require 'httparty'
require 'hashie'
Hash.send :include, Hashie::HashExtensions

libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'klout/version'
require 'klout/identity'
require 'klout/user'

module Klout
  class << self
    # Allow Klout.api_key = "..."
    def api_key=(api_key)
      Klout.api_key = api_key
    end

    def base_uri=(uri)
      Klout.base_uri uri
    end

    # Allows the initializer to turn off actually communicating to the REST service for certain environments
    # Requires fakeweb gem to be installed
    def disable
      FakeWeb.register_uri(:any, %r|#{Regexp.escape(Klout.base_uri)}|, :body => '{"Disabled":true}', :content_type => 'application/json; charset=utf-8')
    end
  end

  # Represents a Klout API error and contains specific data about the error.
  class KloutError < StandardError
    attr_reader :data
    def initialize(data)
      @data = Hashie::Mash.new(data)
      super "The Klout API responded with the following error - #{data}"
    end
  end

  class ClientError < StandardError; end
  class ServerError < StandardError; end
  class BadRequest < KloutError; end
  class Unauthorized < StandardError; end
  class NotFound < ClientError; end
  class Unavailable < StandardError; end

  class Klout
    include HTTParty

    @@base_uri = "http://api.klout.com/v2/"
    @@api_key = ""
    headers({ 
      'User-Agent' => "klout-rest-#{VERSION}",
      'Content-Type' => 'application/json; charset=utf-8',
      'Accept-Encoding' => 'gzip, deflate'
    })
    base_uri @@base_uri

    class << self
      # Get the API key
      def api_key; @@api_key end
      
      # Set the API key
      def api_key=(api_key)
        return @@api_key unless api_key
        @@api_key = api_key
      end

      # Get the Base URI.
      def base_uri; @@base_uri end

      def get(*args); handle_response super end
      def post(*args); handle_response super end
      def put(*args); handle_response super end
      def delete(*args); handle_response super end

      def handle_response(response) # :nodoc:
        case response.code
        when 400
          raise BadRequest.new response.parsed_response
        when 401
          raise Unauthorized.new
        when 404
          raise NotFound.new
        when 400...500
          raise ClientError.new response.parsed_response
        when 500...600
          raise ServerError.new
        else
          response
        end
      end
    end
  end
end