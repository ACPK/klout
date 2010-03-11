require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Klout" do
  
  before do
    Klout.api_key = ""
  end
  
  it "should assign the correct API key" do
    Klout.api_key.should == ""
  end
  
  context "score request" do
    before do
      @score_request ||= lambda {
        Klout.score('jasontorres')
      }
      
      @score_result ||= @score_request.call
    end
    
    it "should score!" do
      @score_result.should be_instance_of(Hash)
    end
    
    it "should have the required keys" do
      @score_result.has_key?('user').should == true
      @score_result['user'].has_key?('kscore').should == true
      @score_result['user'].has_key?('status').should == true
      @score_result['user'].has_key?('status_message').should == true
    end
  end
  
  context "profile request" do
    before do
      @profile_request ||= lambda {
        Klout.profile('jasontorres')
      }
      @profile_result ||= @profile_request.call
    end
    
    it "should have a profile" do
      @profile_result.should be_instance_of(Hash)
    end
    
    it "should have the required keys" do
      @profile_result.has_key?('user').should == true
      @profile_result['user'].has_key?('score').should == true
      @profile_result['user']['score'].has_key?('slope').should == true
      @profile_result['user']['score'].has_key?('kscore').should == true
      @profile_result['user']['score'].has_key?('kclass').should == true
      @profile_result['user']['score'].has_key?('true_reach').should == true
      @profile_result['user']['score'].has_key?('amplification_score').should == true
      @profile_result['user']['score'].has_key?('kscore_description').should == true
      @profile_result['user']['score'].has_key?('network_score').should == true
      @profile_result['user']['score'].has_key?('kclass_description').should == true
      @profile_result['user']['score'].has_key?('date_updated').should == true
      @profile_result['user'].has_key?('twitter_screen_name').should == true
      @profile_result['user'].has_key?('status').should == true
      @profile_result['user'].has_key?('twitter_id').should == true
      @profile_result['user'].has_key?('status_message').should == true
    end
    
  end
  
  
end

