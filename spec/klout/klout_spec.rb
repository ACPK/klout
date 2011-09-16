require 'spec_helper'

module Klout
  describe API do
    
    API_URL         = "http://api.klout.com/1"
    API_URL_SECURE  = "http://api.klout.com:443/1"

    it "requires an API key" do
      expect {Klout::API.new}.should raise_error(ArgumentError)
    end
    
    it "also accepts config options" do
      expect {Klout::API.new(@api_key, {:secure => true})}.should_not raise_error(ArgumentError)
    end
    
    it "requires username passed to methods" do
      k = Klout::API.new(@apikey)
      expect {k.klout}.should raise_error(ArgumentError)
    end

    it "can make a request to the API" do
      FakeWeb.register_uri(:get, "#{API_URL}/klout.json?key=#{@api_key}&users=testuser", :body => @json_response)
      k = Klout::API.new(@api_key)
      k.klout('testuser')['status'].should eq(200)
    end
    
    it "can make a secure request to the API" do
      FakeWeb.register_uri(:get, "#{API_URL_SECURE}/klout.json?key=#{@api_key}&users=testuser", :body => @json_response)
      k = Klout::API.new(@api_key, {:secure => true})
      k.klout('testuser')['users'].first['kscore'].should eq("30.01")
    end
    
    it "can return XML from the API" do
      FakeWeb.register_uri(:get, "#{API_URL}/klout.xml?key=#{@api_key}&users=testuser", :body => @xml_response)
      k = Klout::API.new(@api_key, {:format => 'xml'})
      k.klout('testuser')['user'].first['kscore'].should eq("30.01")
    end

    it "injects the 'user' prefix for user requests" do
      FakeWeb.register_uri(:get, "#{API_URL}/users/show.json?key=#{@api_key}&users=testuser", :body => @json_response)
      k = Klout::API.new(@api_key)
      k.show('testuser')['status'].should eq(200)
    end

    it "injects the 'soi' prefix for influence requests" do
      FakeWeb.register_uri(:get, "#{API_URL}/soi/influenced_by.json?key=#{@api_key}&users=testuser", :body => @json_response)
      k = Klout::API.new(@api_key)
      k.influenced_by('testuser')['status'].should eq(200)
    end

    it "only responds to methods supported by the Klout API" do
      FakeWeb.register_uri(:get, "#{API_URL}/bogus_method.json?key=#{@api_key}&users=twitter", :status => ["404", "Not Found"])
      k = Klout::API.new(@api_key)
      k.respond_to?("bogus_method").should eq(false)
    end
  end
end