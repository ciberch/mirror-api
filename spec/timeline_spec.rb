require_relative "spec_helper"

describe Mirror::API do
  before do
    stub_request(:post, "https://accounts.google.com/o/oauth2/token").
         with(:body => {"client_id"=>"client_id", "client_secret"=>"client_secret", "grant_type"=>"refresh_token", "refresh_token"=>"1/asdasdasdasdas-asdasdasdasdasdas"},
              :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => {access_token: 'access_token_for_testing'}.to_json, :headers => {})
    Mirror.configure do |config|
      config.client_secret  = "client_secret"
      config.client_id  = "client_id"
    end
    @client = Mirror::API.new(refresh_token: '1/asdasdasdasdas-asdasdasdasdasdas')
  end

  describe "insert_timeline" do
    
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
       item = @client.insert_timeline({text: @msg})
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
       item = @client.insert_timeline({random: "123"})
       item.should be_nil
     end
   
    end

  end

  describe "list_timeline" do
    context "without params" do
      before do
        stub_request(:get, "https://www.googleapis.com/mirror/v1/timeline").
           with(headers: json_get_request_headers).
           to_return(status: 200,
                body: fixture("timeline_items.json", true),
                headers: {})
      end

      it "timelines.should_not be_nil " do
        timelines = @client.list_timeline()
        timelines.should_not be_nil
        timelines.nextPageToken.should == "CrABCqIBwnPjUb06gAD__wAA_wG4k56MjNGKjJqN187Nzs3NyMfLy8bL1tGWi5qS18ydy5vNzMjL0pnOnJvSy8aZx9LGyMec0pvJy8mZx8_MnsbLntb_AP7__vfNr_dK___99UdsYXNzLnVzZXIoMTIxMjI3ODQ0OTQpLml0ZW0oM2I0ZDIzNzQtZjFjZC00OWY4LTk3OGMtZDY0NmY4MDNhOTRhKQABEAohllVJNZPLatrwhJV8AQ=="  # see fixture
      end
    end
  end

  def json_post_request_headers(length=0)
    {
        'Accept'=>'application/json',
        'Accept-Encoding'=>'gzip, deflate',
        'Authorization'=>"Bearer #{@client.access_token}",
        'Content-Length'=>length.to_s,
        'Content-Type'=>'application/json',
        'User-Agent'=>'Ruby'
    }
  end
  def json_get_request_headers
    {
        'Accept'=>'application/json',
        'Accept-Encoding'=>'gzip, deflate',
        'Authorization'=>"Bearer #{@client.access_token}",
        'Content-Type'=>'application/json',
        'User-Agent'=>'Ruby'
    }
  end
end