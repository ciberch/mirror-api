module Mirror
  module Configuration
 
    DEFAULT_ENDPOINT = 'https://www.googleapis.com/mirror/v1'
    VALID_CONFIG_KEYS = [:refresh_token, :client_id, :client_secret, :access_token, :endpoint, :logger, :last_error, :last_exception, :throw_on_fail, :response, :data, :creds, :invoke_url, :params, :expected_response, :response]
    attr_accessor *VALID_CONFIG_KEYS
 
    # Make sure we have the default values set when we get 'extended'
    def self.extended(base)
      base.reset
    end
 
    def reset
      self.endpoint = DEFAULT_ENDPOINT
      self.refresh_token = nil
      self.client_secret = nil
      self.client_id = nil
      self.access_token = nil
      self.logger = nil
      self.throw_on_fail = false
      self.last_error = nil
      self.last_exception = nil
      self.response = nil
      self.data = nil
      self.creds = nil
      self.invoke_url = nil
      self.params = nil
      self.expected_response = 200
      self.response = nil
    end

    def configure
      yield self

      self
    end

    def options
      Hash[ * VALID_CONFIG_KEYS.map { |key| [key, send(key)] }.flatten ]
    end

  end
end