require_relative "spec_helper"

describe "Timeline" do
  before do
    @token = "my-token"
    @api = Mirror::Api::Client.new(@token)
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

        it "should insert plain text items passing request data" do
          data = Mirror::Api::RequestData.new({text: @msg})
          item = @api.timeline.create(data)
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

  describe "delete" do
    context "with valid params" do
      before do
        @id = "123123312"
        stub_request(:delete, "https://www.googleapis.com/mirror/v1/timeline/#{@id}").
            with(headers: json_get_request_headers(@token)).
            to_return(status: 200,
                      body: "",
                      headers: {})
      end
      it "should return true" do
        @api.timeline.delete(@id).should be_true
      end
    end

    context "with invalid params" do
      before do
        @id = "blah"
        stub_request(:delete, "https://www.googleapis.com/mirror/v1/timeline/#{@id}").
            with(headers: json_get_request_headers(@token)).
            to_return(status: 400,
                      body: "",
                      headers: {})
      end
      it "should return nil" do
        @api.timeline.delete(@id).should == nil
      end

      it "log the error" do
        logger = Logger.new(STDOUT)
        @api.timeline.options[:logger] = logger
        logger.should_receive(:warn)
        @api.timeline.delete(@id).should == nil
      end
    end

  end

  describe "get" do

    context "with valid params" do
      before do
        @id = "0987"

        stub_request(:get, "https://www.googleapis.com/mirror/v1/timeline/#{@id}").
            with(headers: json_get_request_headers(@token)).
            to_return(status: 200,
                      body: fixture("timeline_item.json", true),
                      headers: {})
      end
      it "should return a timeline with .kind == 'mirror#timelineItem'" do
        timeline_item = @api.timeline.get(@id)
        timeline_item.kind.should == 'mirror#timelineItem'
      end
    end

    context "with invalid params" do
      before do
        @id = "bad_id"

        stub_request(:get, "https://www.googleapis.com/mirror/v1/timeline/#{@id}").
            with(headers: json_get_request_headers(@token)).
            to_return(status: 404,
                      body: fixture("timeline_item.json", true),
                      headers: {})
      end
      it "should return nil" do
        timeline_item = @api.timeline.get(@id)
        timeline_item.should == nil
      end
    end

  end

  describe "list" do

    context "with valid params" do
      before do

        stub_request(:get, "https://www.googleapis.com/mirror/v1/timeline/").
            with(headers: json_get_request_headers(@token)).
            to_return(status: 200,
                      body: fixture("timeline_list.json", true),
                      headers: {})
      end

      it "should return a list of timelines" do
        timeline = @api.timeline.list()
        timeline.should_not be_nil
        timeline.items.count.should == 1  # see fixture
      end
    end

  end

  describe "patch" do

    context "with valid params" do
      before do
        @id = '1234'
        @body = {text: "You realize you are a bad friend right?", menu_items:[{action: "REPLY"}]}
        @body2 = {text: "You realize you are a bad friend right?", menuItems:[{action: "REPLY"}]}

        stub_request(:patch, "https://www.googleapis.com/mirror/v1/timeline/#{@id}").
            with(body: @body2,
                 headers: json_post_request_headers(@token, @body2.to_json)).
            to_return(status: 200,
                      body: fixture("timeline_item.json", true),
                      headers: {})
      end
      it "should return a timeline item with .kind == 'mirror#timelineItem'" do
        timeline = @api.timeline.patch(@id, @body)
        timeline.kind.should == 'mirror#timelineItem'
      end
    end

    context "with invalid params" do
      before do
        @id = '1234'
        @body = {derp: 'troll'}

        stub_request(:patch, "https://www.googleapis.com/mirror/v1/timeline/#{@id}").
            with(body: @body,
                 headers: json_post_request_headers(@token, @body.to_json)).
            to_return(status: 400,
                      body: "",
                      headers: {})
      end
      it "should return nil" do
        timeline = @api.timeline.patch(@id, @body)
        timeline.should == nil
      end
    end

  end

  describe "update" do

    context "with valid params" do
      before do
        @id = '1234'
        @body = {displayName: 'Demo App'}

        stub_request(:put, "https://www.googleapis.com/mirror/v1/timeline/#{@id}").
            with(body: @body,
                 headers: json_post_request_headers(@token, @body.to_json)).
            to_return(status: 200,
                      body: fixture("timeline_item.json", true),
                      headers: {})
      end
      it "should return a timeline item with .kind == 'mirror#timelineItem'" do
        timeline = @api.timeline.update(@id, @body)
        timeline.kind.should == 'mirror#timelineItem'
      end
    end

    context "with invalid params" do
      before do
        @id = '1234'
        @body = {derp: 'troll'}

        stub_request(:put, "https://www.googleapis.com/mirror/v1/timeline/#{@id}").
            with(body: @body,
                 headers: json_post_request_headers(@token, @body.to_json)).
            to_return(status: 400,
                      body: "",
                      headers: {})
      end
      it "should return nil" do
        timeline = @api.timeline.update(@id, @body)
        timeline.should == nil
      end
    end

  end

end