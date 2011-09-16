module Klout
  class API
    # Blank slate
    instance_methods.each do |m|
      undef_method m unless m.to_s =~ /^__|object_id|method_missing|respond_to?|to_s|inspect/
    end
    
    # Initialize
    def initialize(api_key, config = {})
      defaults = {
        :format   => 'json',
        :secure   => false
      }
      @config = defaults.merge(config).freeze
      @api_key = api_key
      protocol = @config[:secure] ? 'https' : 'http'
      api_base = URI.parse("#{protocol}://api.klout.com/")
      @klout_api = Net::HTTP.new(api_base.host, api_base.port)
    end
    
    # Class Methods
    def call(api_method, usernames)
      path = '/1'
      path += '/users' if ['show', 'topics'].include?(api_method.to_s)
      path += '/soi' if ['influenced_by', 'influencer_of'].include?(api_method.to_s)
      path += "/#{api_method}.#{@config[:format]}"
      path += "?key=#{@api_key}"
      path += "&users=#{URI.escape(usernames.gsub(/ /,''))}"
      url = Net::HTTP::Get.new(path)
      response = @klout_api.request(url)
      # TODO: Clean this up when Klout fixes their ambiguous 404 responses.
      raise APIError.new(response.code, response.message) if response.code.to_i > 202
      return nil if response.body == ''
      @config[:format] == 'xml' ? XmlSimple.xml_in(response.body, {'ForceArray' => false}) : JSON.parse(response.body)
    end
    
    def method_missing(api_method, *args) # :nodoc:
      call(api_method, *args)
    # TODO: Need Klout to fix their ambiguous 404 responses.
    #rescue Klout::APIError => error
      #super if error.message == "<404> Not Found"
    end
    
    def respond_to?(api_method) # :nodoc:
      call(api_method, 'twitter')
    rescue Klout::APIError => error
      error.message == "<404> Not Found" ? false : true
    end
  end
  
  class APIError < StandardError
    # Initialize
    def initialize(code, message)
      super "<#{code}> #{message}"
    end
  end
end