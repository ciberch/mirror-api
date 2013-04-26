require_relative "spec_helper"

describe Mirror::Api::OAuth do
  before do
    @oauth = Mirror::Api::OAuth.new('client_id', 'client_secret', 'refresh_token')
  end
  describe "get_access_token" do
    context "has valid params" do
      before do
        @body = {client_id: @oauth.client_id, client_secret: @oauth.client_secret, refresh_token: @oauth.refresh_token, grant_type: "refresh_token"}

        stub_request(:post, "https://accounts.google.com/o/oauth2/token").
           with(body: @body,
                headers: json_post_request_headers(@body.to_json)).
          to_return(status: 200,
            body: fixture("oauth_response.json", true),
            headers: {})
      end
      it "should return a valid access_token" do
        access_token = @oauth.get_access_token
        access_token.should == "BOOYAH"
      end
    end
    
  end

  def json_post_request_headers(body)
    {
      'Accept'=>'*/*',
      'Content-Type'=>'application/x-www-form-urlencoded',
      'User-Agent'=>'Ruby'
    }
  end

end