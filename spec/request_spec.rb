require "spec_helper"

describe Mirror::Api::Request do

  before do
    @creds = {:token => "swewew"}
  end

  describe "initialize" do
    it 'should create a Request' do
      req = Mirror::Api::Request.new(@creds)
      req.resource == Mirror::Api::Request::TIMELINE
    end

    describe "params" do
      it "should take a RequestData" do
        data = Mirror::Api::RequestData.new({params: {text: "abc"}})
        req = Mirror::Api::Request.new(@creds, data)
        req.params.text.should == "abc"
      end

      it "should take a hash" do
        req = Mirror::Api::Request.new(@creds, {params: {text: "abc"}})
        req.params.text.should == "abc"
      end

      it "should ignore empty hashes" do
        req = Mirror::Api::Request.new(@creds, {})
        req.params.should be_nil
      end

      it "should throw an error for other data types" do
        expect {Mirror::Api::Request.new(@creds, {params: 45})}.to raise_error
      end
    end
  end
end