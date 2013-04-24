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
                    headers: json_get_request_headers).
               to_return(status: 422, body: {}.to_json,
                         headers: {})
         end

         it "should not insert the item" do

           item = @api.timeline.create({random: "123"})
           item.should be_nil
         end

       end

      end
    end
  end

  describe "locations" do
   
    describe "get" do

      context "with valid params" do
        before do
          @id = "0987"

          stub_request(:get, "https://www.googleapis.com/mirror/v1/locations/#{@id}").
                  with(headers: json_get_request_headers).
             to_return(status: 200,
                       body: fixture("locations_item.json", true),
                       headers: {})
        end

      it "should get the location for @id", :focus => true do
        location = @api.locations.get(@id)
        location.should_not be_nil
        location.displayName.should == "Home"  # see fixture
      end
    end

    context "with invalid params" do
      before do
        @id = "0987asdasds"

        # TODO: Verify error code is 422
        stub_request(:get, "https://www.googleapis.com/mirror/v1/locations/").
          with(headers: json_post_request_headers).
            to_return(status: 422, body: {}.to_json,
                       headers: {})
        end

        it "should not get the item" do

          item = @api.timeline.create({random: "123"})
          item.should be_nil
        end
      end
    end 
    describe "list" do

      context "with valid params" do
        before do

          stub_request(:get, "https://www.googleapis.com/mirror/v1/locations/").
                  with(headers: json_get_request_headers).
                    to_return(status: 200,
                       body: fixture("locations_list.json", true),
                       headers: {})
        end

        it "should return a list of ids", :focus => true do
          locations = @api.locations.list()
          locations.should_not be_nil
          locations.items.count.should == 2  # see fixture
        end
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

  def json_get_request_headers
    {
        'Accept'=>'application/json',
        'Accept-Encoding'=>'gzip, deflate',
        'Authorization'=>"Bearer #{@token}",
        'Content-Type'=>'application/json',
        'User-Agent'=>'Ruby'
    }
  end

end