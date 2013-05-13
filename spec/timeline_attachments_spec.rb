require_relative "spec_helper"

describe "Timeline Attachments" do

  before do
    @token = "my-token"
    @api = Mirror::Api::Client.new(@token)
  end

  context "delete" do
    context "with valid params" do
      before do
        @timeline_id = "1234"
        @attachment_id = "123123312"
        stub_request(:delete, "https://www.googleapis.com/mirror/v1/timeline/#{@timeline_id}/attachments/#{@attachment_id}").
            with(headers: json_get_request_headers(@token)).
            to_return(status: 200,
                      body: "",
                      headers: {})
      end
      it "should return true" do
        @api.timeline.delete(@timeline_id, {attachments:{id: @attachment_id}}).should be_true
      end
    end

    context "with invalid params" do
      before do
        @timeline_id = "1234"
        @attachment_id = "blah"
        stub_request(:delete, "https://www.googleapis.com/mirror/v1/timeline/#{@timeline_id}/attachments/#{@attachment_id}").
            with(headers: json_get_request_headers(@token)).
            to_return(status: 400,
                      body: "",
                      headers: {})
      end
      it "should return nil" do
        timeline_attachment = @api.timeline.delete(@timeline_id, {attachments:{id: @attachment_id}})
        timeline_attachment.should == nil
      end
    end
  end

  context "get" do
    context "with valid params" do
      before do
        @timeline_id = "1234"
        @attachment_id = "123123312"
        stub_request(:get, "https://www.googleapis.com/mirror/v1/timeline/#{@timeline_id}/attachments/#{@attachment_id}").
            with(headers: json_get_request_headers(@token)).
            to_return(status: 200,
                      body: fixture("timeline_item_attachments_item.json", true),
                      headers: {})
      end
      it "should return timeline_attachment with id '1234'" do
        timeline_attachment = @api.timeline.get(@timeline_id, {attachments:{id: @attachment_id}})
        timeline_attachment.id == '1234'
      end

      it "should return isProcessingContent with boolean false" do
        timeline_attachment = @api.timeline.get(@timeline_id, {attachments:{id: @attachment_id}})
        timeline_attachment.is_processing_content == false
      end
    end

    context "with invalid params" do
      before do
        @timeline_id = "1234"
        @attachment_id = "blah"
        stub_request(:get, "https://www.googleapis.com/mirror/v1/timeline/#{@timeline_id}/attachments/#{@attachment_id}").
            with(headers: json_get_request_headers(@token)).
            to_return(status: 404,
                      body: "",
                      headers: {})
      end
      it "should return nil" do
        timeline_attachment = @api.timeline.get(@timeline_id, {attachments:{id: @attachment_id}})
        timeline_attachment.should == nil
      end
    end
  end

  context "insert" do
     context "with valid params", focus: true do
       before do
         @timeline_id = "1234"
         @file = fixture('files/fry.png')
         @params = {text: "Hello"}

         @double = double("response", body: {'id' => @timeline_id, 'text' => "Hello"}.to_json, code: 200)
         RestClient.stub(:post).and_return(@double)
       end

       it "should return timeline_attachment with id '1234'" do
         item = @api.timeline.insert(@params, @file)
         item.should_not be_nil
         item.text.should == "Hello"
         item.id.should == @timeline_id
       end
     end
  end

  # TODO correct resource#list method to handle attachments
  context "list" do
    context "with valid params" do
      before do
        @timeline_id = "1234"
        stub_request(:get, "https://www.googleapis.com/mirror/v1/timeline/#{@timeline_id}/attachments/").
            with(headers: json_get_request_headers(@token)).
            to_return(status: 200,
                      body: fixture("timeline_item_attachments_list.json", true),
                      headers: {})
      end

      it "should return a list of contacts", :focus => true do
        attachments = @api.timeline.list(@timeline_id, {attachments: {} })
        attachments.should_not be_nil
        attachments.items.count.should == 2  # see fixture
      end
    end
  end

end