module Mirror
  module Api
    class OAuth
      attr_reader :client_id, :client_secret, :refresh_token
      def initialize(client_id, client_secret, refresh_token)
        @client_id = client_id
        @client_secret = client_secret
        @refresh_token = refresh_token
      end

      def get_access_token
        req = Net::HTTP::Post.new("/o/oauth2/token")
        req.set_form_data(client_id: self.client_id, client_secret: self.client_secret, refresh_token: self.refresh_token, grant_type: "refresh_token")
        res = Net::HTTP.start("accounts.google.com", use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE) { |http| http.request(req) }
        result = JSON.parse(res.body)

        if result
          if result["access_token"]
            result["access_token"]
          elsif result["error"]
            raise "Error in get_access_token #{result["error"]}"
          end
        end
      end

    end
  end
end