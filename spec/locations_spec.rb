require_relative "spec_helper"

describe "Locations" do
  before do
    @token = "my-token"
    @api = Mirror::Api::Client.new(@token)
    @api_error_bubble = Mirror::Api::Client.new(@token)
  end

  describe "get" do

    context "with valid params" do
      before do
        @id = "0987"

        stub_request(:get, "https://www.googleapis.com/mirror/v1/locations/#{@id}").
            with(headers: json_get_request_headers(@token)).
            to_return(status: 200,
                      body: fixture("locations_item.json", true),
                      headers: {})
      end

      it "should get the location for @id" do
        location = @api.locations.get(@id)
        location.should_not be_nil
        location.displayName.should == "Home" # see fixture
      end
    end

    context "with invalid params" do
      before do
        @id = "0987asdasds"

        stub_request(:get, "https://www.googleapis.com/mirror/v1/locations/#{@id}").
            with(headers: json_get_request_headers(@token)).
            to_return(status: 404, body: "",
                      headers: {})

      end

      it "should not get the item" do

        item = @api.locations.get(@id)
        item.should be_nil
      end
    end
  end

  describe "list" do

    context "with valid params" do
      before do

        stub_request(:get, "https://www.googleapis.com/mirror/v1/locations/").
            with(headers: json_get_request_headers(@token)).
            to_return(status: 200,
                      body: fixture("locations_list.json", true),
                      headers: {})
      end

      it "should return a list of locations" do
        locations = @api.locations.list()
        locations.should_not be_nil
        locations.items.count.should == 2 # see fixture
      end
    end
  end

end