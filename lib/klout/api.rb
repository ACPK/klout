module Klout
  class API
    # Initialize
    def initialize(api_key, config = {})
      defaults = {
        :secure   => false,
        :version  => 2
      }
      config = defaults.merge(config).freeze
      @api_key = api_key
      @klout_api = "#{config[:secure] ? 'https' : 'http'}://api.klout.com/v#{config[:version]}"
    end
    
    def identity(id, network = :tw)
      params = id.is_a?(Integer) ? "/#{id}?key=#{@api_key}" : "?screenName=#{id}&key=#{@api_key}"
      call("#{@klout_api}/identity.json/#{network.to_s}#{params}")
    end
    
    def users(klout_id, trait)
      call("#{@klout_api}/users.json/#{klout_id}/#{trait.to_s}?key=#{@api_key}")
    end
    
    def call(api_url) # :nodoc:
      response = HTTPI.get(api_url)
      response.code.to_i == 200 ? JSON.parse(response.body) : raise(API::Error.new(response.code, response.body))
      # TODO: How does Klout return errors now?
    end
    
    class Error < StandardError
      def initialize(code, message)
        super "(#{code}) #{message}"
      end
    end
  end
end