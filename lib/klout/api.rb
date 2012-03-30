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
    
    def identity(user, network = :tw)
      user = user.is_a?(Integer) ? "/#{user}" : "?screenName=#{user}"
      api_url = "#{@klout_api}/identity.json/#{network.to_s}#{user}&key=#{@api_key}"
      call(api_url)
    end
    
    def users(klout_id, trait)
      api_url = "#{@klout_api}/users.json/#{klout_id}/#{trait.to_s}&key=#{@api_key}"
      call(api_url)
    end
    
    def call(api_url) # :nodoc:
      response = HTTPI.get(api_url)
      response.code.to_i == 200 ? JSON.parse(response.body) : raise(Error.new(response.code, response.body))
      # TODO: How does Klout return errors now?
    end
  end
  
  class Error < StandardError
    def initialize(code, message)
      super "<#{code}> #{message}"
    end
  end
end