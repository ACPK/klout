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
    
    def identity(user, network = "tw")
      user = user.is_a? String ? "?screenName=#{user}" : "/#{user}"
      api_url = "#{@klout_api}/identity.json/#{network}#{user}&key=#{@api_key}"
      response = HTTPI.get(api_url)
      JSON.parse(response.body)
    end
    
    def users(klout_id, trait)
      api_url = "#{@klout_api}/users.json/#{klout_id}/#{trait.to_s}&key=#{@api_key}"
      response = HTTPI.get(api_url)
      JSON.parse(response.body)
    end
    
    def call(api_method, *args)
    
  end
  
  # TODO: Figure out error responses and raise Ruby errors when appropriate.
  #       HTTP error handling (403, 404, 422, 500)
  #       Klout error responses
end

# k = Klout::API.new(key)
# k.identity('bgetting', :tw)
# k.identity(1234567, :tw)
# k.identity('bgetting', :ks)
#
# k.users(1234abcd567, :score)
# k.users(1234abcd567, :influence)
# k.users(1234abcd567, :topics)