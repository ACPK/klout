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
      user = user.is_a? Integer ? "/#{user}" : "?screenName=#{user}"
      api_url = "#{@klout_api}/identity.json/#{network.to_s}#{user}&key=#{@api_key}"
      call(api_url)
    end
    
    def users(klout_id, trait)
      api_url = "#{@klout_api}/users.json/#{klout_id}/#{trait.to_s}&key=#{@api_key}"
      call(api_url)
    end
    
    def call(api_url)
      response = HTTPI.get(api_url)
      JSON.parse(response.body)
      # TODO: Handle errors
    end
  end
end