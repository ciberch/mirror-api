require "rest-client"
require "json"
require "hashie/mash"

module Mirror
  module Api

    class Base

      attr_accessor :last_error, :logger, :host, :last_exception, :throw_on_fail, :response, :data, :creds

      def initialize(credentials, throw_on_fail=true, host="https://www.googleapis.com", logger=nil)
        @creds = credentials
        @last_exception = nil
        @throw_on_fail = throw_on_fail
        @host = host
        @logger = logger
        @last_error = nil
      end

      public
      def post(json=false)
        do_verb(:post, json)
      end

      def put(json=false)
        do_verb(:put, json)
      end

      def delete
        get_verb(:delete)
      end

      def get
        get_verb
      end

      protected

      def invoke_url; end
      def params; end
      def send_error; end

      def handle_http_response(response, request, result, &block)
        @request = request
        case response.code
          when 422
            if @logger
              msg = "ERROR - Rejected #{request.inspect} to #{self.invoke_url} with params #{self.params}. Response is #{response.body}"
              @logger.error(msg)
            end
            response
          else
            response.return!(request, result, &block)
        end
      end

      def expected_response
        200
      end

      def successful_response?
        @response and @response.code == expected_response
      end

      def ret_val
        @data
      end

      def headers
        {
            "Accept" => "application/json",
            "Content-type" => "application/json",
            "Authorization" => "Bearer #{@creds[:token]}"
        }
      end

      def handle_response
        if successful_response?
          ret_val
        else
          send_error
        end
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
        @data = JSON.parse(@response.body) if @response and @response.body
      end

      def handle_http_exception(verb, ex)
        handle_exception("INTERNAL_ERROR", "Could not #{verb} to #{self.invoke_url}", ex, self.params)
      end

      def do_verb(verb=:post, json=false)
        begin
          data = json ? self.params.to_json : self.params
          @response = RestClient.send(verb, self.invoke_url, data, self.headers) do |response, request, result, &block|
            handle_http_response(response, request, result, &block)
          end
          set_data
          handle_response
        rescue => ex
          return handle_http_exception(verb, ex)
        end
      end

      def get_verb(verb=:get)
        begin
          @response = RestClient.send(verb, self.invoke_url, self.headers)
          set_data
          handle_response
        rescue => ex
          return handle_http_exception(verb, ex)
        end
      end
    end


  end
end