require_relative "spec_helper"

describe "Contacts" do

  before do
    @token = "my-token"
    @api = Mirror::Api::Client.new(@token)
  end

  describe "delete" do
    context "with valid params" do
      before do
        @id = "123123312"
        stub_request(:delete, "https://www.googleapis.com/mirror/v1/contacts/#{@id}").
            with(headers: json_get_request_headers(@token)).
            to_return(status: 200,
                      body: "",
                      headers: {})
      end
      it "should return true" do
        @api.contacts.delete(@id).should be_true
      end
    end

    context "with invalid params" do
      before do
        @id = "blah"
        stub_request(:delete, "https://www.googleapis.com/mirror/v1/contacts/#{@id}").
            with(headers: json_get_request_headers(@token)).
            to_return(status: 400,
                      body: "",
                      headers: {})
      end
      it "should return nil" do
        contact = @api.contacts.delete(@id)
        contact.should == nil
      end
    end

  end

  describe "get" do

    context "with valid params" do
      before do
        @id = "0987"

        stub_request(:get, "https://www.googleapis.com/mirror/v1/contacts/#{@id}").
            with(headers: json_get_request_headers(@token)).
            to_return(status: 200,
                      body: fixture("contacts_item.json", true),
                      headers: {})
      end
      it "should return a contact with .kind == 'mirror#contact'" do
        contact = @api.contacts.get(@id)
        contact.kind.should == 'mirror#contact'
      end
    end

    context "with invalid params" do
      before do
        @id = "bad_id"

        stub_request(:get, "https://www.googleapis.com/mirror/v1/contacts/#{@id}").
            with(headers: json_get_request_headers(@token)).
            to_return(status: 404,
                      body: fixture("contacts_item.json", true),
                      headers: {})
      end
      it "should return nil" do
        contact = @api.contacts.get(@id)
        contact.should == nil
      end
    end

  end

  describe "insert" do

    context "with valid params" do
      before do
        @body = {id: '1234', displayName: 'Demo App', imageUrls: ["http://pixelr3ap3r.com/wp-content/uploads/2012/08/357c6328ee4b11e1bfbf22000a1c91a7_7.jpg"]}

        stub_request(:post, "https://www.googleapis.com/mirror/v1/contacts/").
            with(body: @body,
                 headers: json_post_request_headers(@token, @body.to_json)).
            to_return(status: 200,
                      body: fixture("contacts_item.json", true),
                      headers: {})
      end
      it "should return a contact with .kind == 'mirror#contact'" do
        contact = @api.contacts.insert(@body)
        contact.kind.should == 'mirror#contact'
      end
    end

    context "with invalid params" do
      before do
        @body = {canIHazContact: "Really you thought that was valid?!"}

        stub_request(:post, "https://www.googleapis.com/mirror/v1/contacts/").
            with(body: @body,
                 headers: json_post_request_headers(@token, @body.to_json)).
            to_return(status: 404,
                      body: "",
                      headers: {})
      end
      it "should return nil" do
        contact = @api.contacts.insert(@body)
        contact.should == nil
      end
    end

  end

  describe "list" do

    context "with valid params" do
      before do

        stub_request(:get, "https://www.googleapis.com/mirror/v1/contacts/").
            with(headers: json_get_request_headers(@token)).
            to_return(status: 200,
                      body: fixture("contacts_list.json", true),
                      headers: {})
      end

      it "should return a list of contacts" do
        contacts = @api.contacts.list()
        contacts.should_not be_nil
        contacts.items.count.should == 2  # see fixture
      end
    end

  end

  describe "patch" do

    context "with valid params" do
      before do
        @id = '1234'
        @body = {displayName: 'Demo App'}

        stub_request(:patch, "https://www.googleapis.com/mirror/v1/contacts/#{@id}").
            with(body: @body,
                 headers: json_post_request_headers(@token, @body.to_json)).
            to_return(status: 200,
                      body: fixture("contacts_item.json", true),
                      headers: {})
      end
      it "should return a contact with .kind == 'mirror#contact'" do
        contact = @api.contacts.patch(@id, @body)
        contact.kind.should == 'mirror#contact'
      end
    end

    context "with invalid params" do
      before do
        @id = '1234'
        @body = {derp: 'troll'}

        stub_request(:patch, "https://www.googleapis.com/mirror/v1/contacts/#{@id}").
            with(body: @body,
                 headers: json_post_request_headers(@token, @body.to_json)).
            to_return(status: 400,
                      body: "",
                      headers: {})
      end
      it "should return nil" do
        contact = @api.contacts.patch(@id, @body)
        contact.should == nil
      end
    end

  end

  describe "update" do

    context "with valid params" do
      before do
        @id = '1234'
        @body = {displayName: 'Demo App'}

        stub_request(:put, "https://www.googleapis.com/mirror/v1/contacts/#{@id}").
            with(body: @body,
                 headers: json_post_request_headers(@token, @body.to_json)).
            to_return(status: 200,
                      body: fixture("contacts_item.json", true),
                      headers: {})
      end
      it "should return a contact with .kind == 'mirror#contact'" do
        contact = @api.contacts.update(@id, @body)
        contact.kind.should == 'mirror#contact'
        contact.phone_number.should == "1234345587"
      end
    end

    context "with invalid params" do
      before do
        @id = '1234'
        @body = {derp: 'troll'}

        stub_request(:put, "https://www.googleapis.com/mirror/v1/contacts/#{@id}").
            with(body: @body,
                 headers: json_post_request_headers(@token, @body.to_json)).
            to_return(status: 400,
                      body: "",
                      headers: {})
      end
      it "should return nil" do
        contact = @api.contacts.update(@id, @body)
        contact.should == nil
      end
    end

  end

end