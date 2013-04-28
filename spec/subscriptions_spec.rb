require_relative "spec_helper"

describe "Subscriptions" do
  before do
    @token = "my-token"
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
        @api = Mirror::Api::Client.new(@token)
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

      context "without bubbling errors" do
        it "should return nil" do
          @api = Mirror::Api::Client.new(@token)
          subscription = @api.subscriptions.delete(@id)
          subscription.should == nil
        end
      end

      context "bubbling errors" do
        it "should raise ex" do
          @api = Mirror::Api::Client.new(@token, true)
          expect{@api.subscriptions.delete(@id)}.to raise_error
        end
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
        @api = Mirror::Api::Client.new(@token)
        subscription = @api.subscriptions.insert(@body)
        subscription.kind.should == 'mirror#subscription'
      end
    end

    context "with invalid params" do
      before do
        @body2 = {:notCoolDude => "Really you thought that was valid?!"}
        stub_request(:post, "https://www.googleapis.com/mirror/v1/subscriptions/").
            with(body: @body2,
                 headers: json_post_request_headers(@token, @body2.to_json)).
            to_return(status: 404,
                      body: {},
                      headers: {})
      end
      it "should return nil" do
        @api = Mirror::Api::Client.new(@token)
        subscription = @api.subscriptions.insert({not_cool_dude: "Really you thought that was valid?!"})
        subscription.should == nil
      end

      context "bubbling errors" do
        it "should raise ex" do
          @api = Mirror::Api::Client.new(@token, true)
          expect{@api.subscriptions.insert(@body)}.to raise_error
        end
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
        @api = Mirror::Api::Client.new(@token)
        subscriptions = @api.subscriptions.list
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
        @api = Mirror::Api::Client.new(@token)
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
        @api = Mirror::Api::Client.new(@token)
        subscription = @api.subscriptions.update(@id, @body)
        subscription.should == nil
      end

      context "when bubbling errors" do

        it "should raise an exception" do
          @api = Mirror::Api::Client.new(@token, true)
          expect{@api.subscriptions.update(@id, @body)}.to raise_error
        end
      end
    end

  end
end