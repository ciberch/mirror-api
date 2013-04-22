require 'spec_helper'
describe Mirror::Configuration do
 
  describe '.refresh_token' do
    it 'should return default key' do
      Mirror.refresh_token.should == nil 
    end
  end

  describe '.endpoint' do
    it 'should return default key' do
      Mirror.endpoint.should == Mirror::Configuration::DEFAULT_ENDPOINT 
    end
  end

  describe '.client_secret' do
    it 'should return default key' do
      Mirror.client_secret.should == nil
    end
  end
 
  describe '.client_id' do
    it 'should return default key' do
      Mirror.client_id.should == nil
    end
  end

  describe '.access_token' do
    it 'should return default key' do
      Mirror.access_token.should == nil
    end
  end
  
end