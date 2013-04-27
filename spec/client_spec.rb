require_relative "spec_helper"

describe Mirror::Api::Client do
  before do
    @token = "my-token"
  end

  describe "initializing" do
    it "should take the token as a string" do
      @api = Mirror::Api::Client.new(@token)
      @api.should_not be_nil
      @api.credentials[:token].should == @token
    end

    it "should take the credentials hash" do
      hash = {:token => @token}
      @api = Mirror::Api::Client.new(hash)
      @api.should_not be_nil
      @api.credentials.should == hash
    end

    it "should raise an error if invalid params" do
      expect{@api = Mirror::Api::Client.new(nil)}.to raise_error "Invalid credentials. Missing token"
    end
  end

  describe "methods" do
    it "should have methods that match the mirror api" do
      @api = Mirror::Api::Client.new(@token)
      @api.methods.should include(:timeline, :locations, :subscriptions, :contacts)
    end
  end

end