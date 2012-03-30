require 'spec_helper'

module Klout
  describe API do
    
    API_URL         = "http://api.klout.com/v2"
    API_URL_SECURE  = "http://api.klout.com:443/v2"

    it "requires an API key" do
      expect {Klout::API.new}.should raise_error(ArgumentError)
    end
    
    it "also accepts config options" do
      expect {Klout::API.new(@api_key, {:secure => true})}.should_not raise_error(ArgumentError)
    end
    
    
    
  end
end