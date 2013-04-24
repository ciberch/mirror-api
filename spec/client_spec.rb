require_relative "spec_helper"

describe Mirror::Api::Client do
  before do
    @token = "my-token"
    @api = Mirror::Api::Client.new(@token)
  end

  describe "timeline" do
    describe "create" do
      describe "inserting" do

       context "with valid params" do
         before do
           @msg = "Hello world"

           stub_request(:post, "https://www.googleapis.com/mirror/v1/timeline/").
               with(body: {text: @msg},
                    headers: json_post_request_headers).
               to_return(status: 201,
                         body: fixture("timeline_item.json", true),
                         headers: JSON.parse(fixture("timeline_item_response_headers.json", true)))
         end

         it "should insert plain text items", :focus => true do
           item = @api.timeline.create({text: @msg})
           item.should_not be_nil
           item.created.should == "2012-09-25T23:28:43.192Z"  # see fixture
           item.text.should == @msg
         end
       end

       context "with invalid params" do
         before do
           @msg = "Hello world"

           # TODO: Verify error code is 422
           stub_request(:post, "https://www.googleapis.com/mirror/v1/timeline/").
               with(body: {random: "123"},
                    headers: json_post_request_headers).
               to_return(status: 422, body: {}.to_json,
                         headers: {})
         end

         it "should not insert the item" do

           item = @api.timeline.create({random: "123"})
           item.should be_nil
         end
       end
      end

      def json_post_request_headers
        {
            'Accept'=>'application/json',
            'Accept-Encoding'=>'gzip, deflate',
            'Authorization'=>"Bearer #{@token}",
            'Content-Length'=>/\d+/,
            'Content-Type'=>'application/x-www-form-urlencoded',
            'User-Agent'=>'Ruby'
        }
      end
    end
  end
end