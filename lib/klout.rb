require 'uri'
require 'net/http'
require 'rubygems'
require 'json'
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

=begin rdoc

Klout measures influence on topics across the social web to find the people the world listens to

See http://klout.com for more information about their service

Usage:

Klout.api_key = ""
Klout.score('jasontorres')

=end


class Klout
  VERSION = '0.1.1'
  class << self
    @@base_host = "klout.com"
    
    @@api_key = ""

    def api_key=(api)
      @@api_key = api
    end
    
    def api_key
      @@api_key
    end

    def score(usernames)
      request_uri = "http://api.klout.com/1/klout.json?key=#{@@api_key}&users=#{usernames}"
      return request(request_uri)
    end
    
    def profile(usernames)
      request_uri = "http://api.klout.com/1/users/show.json?key=#{@@api_key}&users=#{usernames}"
      return request(request_uri)
    end
    
    def influenced_by(usernames)
      request_uri = "http://api.klout.com/1/soi/influenced_by.json?key=#{@@api_key}&users=#{usernames}"
      return request(request_uri)
    end
    
    def influencer_of(usernames)
      request_uri = "http://api.klout.com/1/soi/influencer_of.json?key=#{@@api_key}&users=#{usernames}"
      return request(request_uri)
    end
    
    def request(request_uri)
      begin
        url = URI.parse(request_uri)
        response = JSON.parse(Net::HTTP.get(url))
        if response["status"] == 200
          response
        else
          nil
        end
      rescue => error
        raise error
      end
    end
  end
end