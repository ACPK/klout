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
  VERSION = '0.0.1'
  class << self
    @@base_host = "klout.com"
    
    @@api_key = ""

    def api_key=(api)
      @@api_key = api
    end
    
    def api_key
      @@api_key
    end

    def score(username)
      request_uri = "http://klout.com/api/twitter/1/klout/#{@@api_key}/#{username}.json"
      return request(request_uri)
    end
    
    def profile(username)
      request_uri = "http://klout.com/api/twitter/1.1/profiledetail/#{@@api_key}/#{username}.json"
      return request(request_uri)
    end
    
    def request(request_uri)
      url = URI.parse(request_uri)
      response = Net::HTTP.start(url.host, url.port) { |http|
        http.get(url.path)
      }
      
      case response
        when Net::HTTPSuccess
          if response.body
            begin 
              JSON.parse(response.body)
            rescue Exception => e
              puts e.backtrace
              false
            end
          end
        else
          response.error!
      end
    end
      
      
    
  end
end