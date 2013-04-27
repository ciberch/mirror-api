require_relative "spec_helper"

describe "Timeline" do
  before do
    @token = "my-token"
    @api = Mirror::Api::Client.new(@token)
    @api_error_bubble = Mirror::Api::Client.new(@token)
  end

  describe "create" do
    describe "inserting" do

      context "with valid params" do
        before do
          @msg = "Hello world"
          @body = {text: @msg}

          stub_request(:post, "https://www.googleapis.com/mirror/v1/timeline/").
              with(body: @body,
                   headers: json_post_request_headers(@token, @body.to_json)).
              to_return(status: 200,
                        body: fixture("timeline_item.json", true),
                        headers: JSON.parse(fixture("timeline_item_response_headers.json", true)))
        end

        it "should insert plain text items" do
          item = @api.timeline.create({text: @msg})
          item.should_not be_nil
          item.created.should == "2012-09-25T23:28:43.192Z" # see fixture
          item.text.should == @msg
        end
      end

      context "with invalid params" do
        before do
          @msg = "123"
          @body = {random: @msg}
          stub_request(:post, "https://www.googleapis.com/mirror/v1/timeline/").
              with(body: @body,
                   headers: json_post_request_headers(@token, @body.to_json)).
              to_return(status: 400, body: "",
                        headers: {})
        end

        it "should not insert the item" do

          item = @api.timeline.create(@body)
          item.should be_nil
        end

      end

    end
  end

end