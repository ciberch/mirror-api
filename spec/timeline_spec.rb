require_relative "spec_helper"

describe Mirror::Timeline do
  before do
    Mirror.configure do |config|
      config.refresh_token = "refresh_token"
      config.client_secret  = "client_secret"
      config.client_id  = "client_id"
      config.access_token = "access_token"
    end
  end

  describe "insert" do
    describe "inserting" do

     context "with valid params" do
       before do
         @msg = "Hello world"
         @body = {text: @msg}.to_json
         stub_request(:post, "https://www.googleapis.com/mirror/v1/timeline").
             with(body: @body,
                  headers: json_post_request_headers(@body.length)).
             to_return(status: 200,
                       body: fixture("timeline_item.json", true),
                       headers: JSON.parse(fixture("timeline_item_response_headers.json", true)))
       end

       it "should insert plain text items" do
         item = Mirror::Timeline.insert({text: @msg})
         item.should_not be_nil
         item.created.should == "2012-09-25T23:28:43.192Z"  # see fixture
         item.text.should == @msg
       end
     end

     context "with invalid params" do
       before do
         @msg = "123"
         @body = {random: @msg}.to_json
         # TODO: Verify error code is 422
         stub_request(:post, "https://www.googleapis.com/mirror/v1/timeline").
             with(body: @body,
                  headers: json_post_request_headers(@body.length)).
             to_return(status: 422, body: {}.to_json,
                       headers: {})
       end

       it "should not insert the item" do
         item = Mirror::Timeline.insert({random: "123"})
         item.should be_nil
       end
     end
    end

    def json_post_request_headers(length)
      {
          'Accept'=>'application/json',
          'Accept-Encoding'=>'gzip, deflate',
          'Authorization'=>"Bearer #{Mirror.access_token}",
          'Content-Length'=>length.to_s,
          'Content-Type'=>'application/json',
          'User-Agent'=>'Ruby'
      }
    end
  end

end