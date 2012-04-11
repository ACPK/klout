require 'spec_helper'

module Klout
  describe API do
    API_URL = "http://api.klout.com/v2/"
    
    describe "initializing" do
      it "requires an API key" do
        expect {Klout::API.new}.should raise_error(ArgumentError)
      end
    end
    
    describe "calling the API" do
      before(:each) do
        @k = Klout::API.new(@api_key)
      end
      
      describe "for a klout_id" do
        it "should accept a Twitter ID" do
          user_id = 500042487
          FakeWeb.register_uri(:get, "#{API_URL}identity.json/tw/#{user_id}?key=#{@api_key}", :body => File.read(File.expand_path('spec/klout/fixtures/identity.json')))
          @k.identity(user_id)['id'].should eq('54887627490056592')
        end
        
        it "should accept a Twitter screen name" do
          screen_name = 'dhh'
          FakeWeb.register_uri(:get, "#{API_URL}identity.json/twitter?screenName=#{screen_name}&key=#{@api_key}", :body => File.read(File.expand_path('spec/klout/fixtures/identity.json')))
          @k.identity(screen_name)['id'].should eq('54887627490056592')
        end
      end
      
      describe "for user" do
        it "should return profile information" do
          FakeWeb.register_uri(:get, "#{API_URL}user.json/#{@klout_id}?key=#{@api_key}", :body => File.read(File.expand_path('spec/klout/fixtures/user.json')))
          @k.user(@klout_id)['kloutId'].to_i.should eq(@klout_id)
        end
        
        it "should return score data" do
          FakeWeb.register_uri(:get, "#{API_URL}user.json/#{@klout_id}/score?key=#{@api_key}", :body => File.read(File.expand_path('spec/klout/fixtures/score.json')))
          @k.user(@klout_id, :score)['score'].should eq(18.162389755249023)
        end
        
        it "should return influence data" do
          FakeWeb.register_uri(:get, "#{API_URL}user.json/#{@klout_id}/influence?key=#{@api_key}", :body => File.read(File.expand_path('spec/klout/fixtures/influence.json')))
          @k.user(@klout_id, :influence)['myInfluencersCount'].to_i.should eq(15)
        end
        
        it "should return topics data" do
          FakeWeb.register_uri(:get, "#{API_URL}user.json/#{@klout_id}/topics?key=#{@api_key}", :body => File.read(File.expand_path('spec/klout/fixtures/topics.json')))
          @k.user(@klout_id, :topics).size.should eq(5)
        end
      end
    end
  end
end