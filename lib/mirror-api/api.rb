require "rest-client"
require "json"
require "hashie/mash"
require_relative "timeline_request"

module Mirror

  class API
    include TimelineRequest
    attr_accessor *Configuration::VALID_CONFIG_KEYS

    def initialize(options={})
      merged_options = Mirror.options.merge(options)
      Configuration::VALID_CONFIG_KEYS.each do |key|
        send("#{key}=", merged_options[key])
      end
      get_access_token unless @refresh_token.nil?
    end

    public
    def post(request={})
      do_verb(:post, request)
    end

    def put(request={})
      do_verb(:put, request_headers)
    end

    def patch(request={})
      do_verb(:put, request)
    end

    def delete(request={})
      get_verb(:delete, request)
    end

    def get(request={})
      get_verb(:get, request)
    end

    protected

    def get_access_token
      req = Net::HTTP::Post.new("/o/oauth2/token")
      req.set_form_data(client_id: self.client_id, client_secret: self.client_secret, refresh_token: @refresh_token, grant_type: "refresh_token")
      res = Net::HTTP.start("accounts.google.com", use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE) { |http| http.request(req) }

      begin
        result = JSON.parse(res.body)
        @access_token = result["access_token"]
      rescue
        raise JSON.parse(res.body)['error']['message']
      end
    end

    def handle_http_response(response, request, result, &block)
      @request = request
      case response.code
        when 400...600
          msg = "ERROR - Rejected #{request.inspect} to #{self.invoke_url} with params #{self.params}. Response is #{response.body}"
          @logger.error(msg) if @logger
          raise msg
        else
          response
      end
    end

    def successful_response?
      @response and @response.code == expected_response
    end

    def headers

      {
          "Accept" => "application/json",
          "Content-type" => "application/json",
          "Authorization" => "Bearer #{Mirror.access_token}"
      }
    end

    def handle_error(error_desc, msg, errors, validation_error=nil, params={})
      @last_error = error_desc.dup
      @last_error[:errors] = errors
      @last_error[:validation_error] = validation_error if validation_error
      msg += " with params #{params}" if params.keys.count > 0
      @logger.warn(msg) if @logger
      raise error_desc[:message] if throw_on_fail
    end

    def handle_exception(error_desc, msg, ex, params={})
      @last_exception = ex
      @last_error = error_desc
      msg += " with params #{params}" if params && params.keys.count > 0
      msg += " due to #{ex}.\n" + ex.backtrace.join("\n")
      @logger.error(msg) if @logger

      raise ex if throw_on_fail
      return nil
    end

    def set_data
      @data = JSON.parse(@response.body)
    end

    def handle_http_exception(verb, ex)
      handle_exception("INTERNAL_ERROR", "Could not #{verb} to #{self.invoke_url}", ex, self.params)
    end

    def do_verb(verb=:post, json=false)
      begin
        data = json ? self.params : self.params.to_json
        @response = RestClient.send(verb, self.invoke_url, data, self.headers) do |response, request, result, &block|
          handle_http_response(response, request, result, &block)
        end
        set_data
      rescue => ex
        return handle_http_exception(verb, ex)
      end
    end

    def get_verb(verb=:get)
      begin
        @response = RestClient.send(verb, self.invoke_url, self.headers)
        set_data
      rescue => ex
        return handle_http_exception(verb, ex)
      end
    end

  end
end