require_relative "spec_helper"

describe "Subscriptions" do
  before do
    @token = "my-token"
    @api = Mirror::Api::Client.new(@token)
  end

  describe "delete" do
    context "with valid params" do
      before do
        @id = "timeline"
        stub_request(:delete, "https://www.googleapis.com/mirror/v1/subscriptions/#{@id}").
            with(headers: json_get_request_headers(@token)).
            to_return(status: 200,
                      body: {},
                      headers: {})
      end
      it "should return true" do
        @api.subscriptions.delete(@id).should be_true
      end
    end

    context "with invalid params" do
      before do
        @id = "blah"
        stub_request(:delete, "https://www.googleapis.com/mirror/v1/subscriptions/#{@id}").
            with(headers: json_get_request_headers(@token)).
            to_return(status: 400,
                      body: {},
                      headers: {})
      end
      it "should return nil" do
        subscription = @api.subscriptions.delete(@id)
        subscription.should == nil
      end
    end

  end

  describe "insert" do

    context "with valid params" do
      before do
        @body = {collection: "timeline", userToken:"user_1", operation: ["UPDATE"], callbackUrl: "https://yourawesomewebsite.com/callback"}

        stub_request(:post, "https://www.googleapis.com/mirror/v1/subscriptions/").
            with(body: @body,
                 headers: json_post_request_headers(@token, @body.to_json)).
            to_return(status: 200,
                      body: fixture("subscriptions_item.json", true),
                      headers: {})
      end
      it "should return a subscription with .kind == 'mirror#subscription'" do
        subscription = @api.subscriptions.insert(@body)
        subscription.kind.should == 'mirror#subscription'
      end
    end

    context "with invalid params" do
      before do
        @body = {not_cool_dude: "Really you thought that was valid?!"}

        stub_request(:post, "https://www.googleapis.com/mirror/v1/subscriptions/").
            with(body: @body,
                 headers: json_post_request_headers(@token, @body.to_json)).
            to_return(status: 404,
                      body: {},
                      headers: {})
      end
      it "should return nil" do
        subscription = @api.subscriptions.insert(@body)
        subscription.should == nil
      end
    end

  end

  describe "list" do

    context "with valid params" do
      before do

        stub_request(:get, "https://www.googleapis.com/mirror/v1/subscriptions/").
            with(headers: json_get_request_headers(@token)).
            to_return(status: 200,
                      body: fixture("subscriptions_list.json", true),
                      headers: {})
      end

      it "should return a list of subscriptions" do
        subscriptions = @api.subscriptions.list()
        subscriptions.should_not be_nil
        subscriptions.items.count.should == 1 # see fixture
      end
    end

  end

  describe "update" do

    context "with valid params" do
      before do
        @id = 'timeline'
        @body = {collection: 'timeline', callbackUrl: 'https://fullscreen.net/callback', operation:["INSERT", "UPDATE"]}

        stub_request(:put, "https://www.googleapis.com/mirror/v1/subscriptions/#{@id}").
            with(body: @body,
                 headers: json_post_request_headers(@token, @body.to_json)).
            to_return(status: 200,
                      body: fixture("subscriptions_item.json", true),
                      headers: {})
      end
      it "should return a subscription with .kind == 'mirror#subscription'" do
        subscription = @api.subscriptions.update(@id, @body)
        subscription.kind.should == 'mirror#subscription'
      end
    end

    context "with invalid params" do
      before do
        @id = 'timeline'
        @body = {derp: 'troll'}

        stub_request(:put, "https://www.googleapis.com/mirror/v1/subscriptions/#{@id}").
            with(body: @body,
                 headers: json_post_request_headers(@token, @body.to_json)).
            to_return(status: 400,
                      body: {},
                      headers: {})
      end
      it "should return nil" do
        subscription = @api.subscriptions.update(@id, @body)
        subscription.should == nil
      end
    end

  end
end