require "rest-client"
require "json"
require "logger"
require_relative "request_data"
require_relative "response_data"
require_relative "errors"

module Mirror
  module Api
    HOST = "https://www.googleapis.com"

    class Request
      TIMELINE = "timeline"
      SUBSCRIPTIONS = "subscriptions"
      LOCATIONS = "locations"
      CONTACTS = "contacts"

      VALID_RESOURCES = [TIMELINE, SUBSCRIPTIONS, LOCATIONS, CONTACTS]

      attr_accessor :last_error, :logger, :host, :last_exception, :throw_on_fail, :response, :data, :creds, :resource, :params


      def initialize(creds, options={})
        self.resource = options[:resource]
        self.params = options[:params]
        self.logger = options[:logger]
        @id = options[:id]

        @expected_response = options[:expected_response]
        @creds = creds
        @last_exception = nil
        @throw_on_fail = options[:raise_errors] || false
        @host = options[:host] || HOST

        @last_error = nil
      end

      def logger=(value)
        if value
          if value.is_a?(Logger)
            @logger = value
          else
            raise "Invalid object given as logger #{value.inspect}"
          end
        end
      end

      def resource=(value)
        if value
          if VALID_RESOURCES.include?(value)
            @resource = value
          else
            raise "Invalid resource name #{value}"
          end
        end
        @resource = TIMELINE unless @resource
      end

      def params=(value)
        if value
          if value.is_a?(RequestData)
            @params = value
          elsif value.is_a?(Hash) && value.keys.count > 0
            @params = RequestData.new(value)
          else
            raise "Parameter #{value.inspect} is not compatible"
          end
        else
          @params = nil
        end
      end

      public
      def post
        do_verb(:post)
      end

      def put
        do_verb(:put)
      end

      def patch
        do_verb(:patch)
      end

      def delete
        get_verb(:delete)
      end

      def get
        get_verb
      end

      protected

      def handle_http_response(response, request, result, &block)
        @request = request
        case response.code
          when 404, 400
            @error_response = response.body
            @error_code = response.code
            @chosen_error = @error_code == 400 ? Mirror::Api::Errors::ERROR_400 : Mirror::Api::Errors::ERROR_404
            if @logger
              msg = "ERROR - #{@error_code} #{request.inspect} to #{self.invoke_url} with params #{self.params}. Response is #{@error_response}"
              @logger.error(msg)
            end
            response
          else
            response.return!(request, result, &block)
        end
      end

      def successful_response?
        @response and @response.code == expected_response
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
          @chosen_error ? send_chosen_error : send_error
        end
      end

      def handle_error(error_desc, msg, errors, validation_error=nil, params={})
        @last_error = error_desc.dup
        @last_error[:errors] = errors
        @last_error[:validation_error] = validation_error if validation_error
        msg += " with params #{params}"
        @logger.warn(msg) if @logger
        if throw_on_fail
          if error_desc[:ex_class]
            raise error_desc[:ex_class].new(@last_error, params)
          else
            raise error_desc[:message]
          end
        end
      end

      def set_data
        if @response and @response.body
          @data = JSON.parse(@response.body) if @response.body.is_a?(String) && !@response.body.empty?
        end
      end

      def do_verb(verb=:post)
        data = self.params.to_json
        @response = RestClient.send(verb, self.invoke_url, data, self.headers) do |response, request, result, &block|
          handle_http_response(response, request, result, &block)
        end
        set_data
        handle_response
      end

      def get_verb(verb=:get)
        @response = RestClient.send(verb, self.invoke_url, self.headers) do |response, request, result, &block|
          handle_http_response(response, request, result, &block)
        end
        set_data
        handle_response
      end

      def invoke_url
        return @invoke_url unless @invoke_url.nil?
        @invoke_url ="#{self.host}/mirror/v1/#{@resource}/#{@id ? @id : ''}"
        @invoke_url += "/attachments/#{attachment_id ? attachment_id : ''}" if attachments
        @invoke_url
      end

      def attachment_id
        attachments[:id] if attachments
      end

      def attachments
        params.attachments if params
      end

      def ret_val
        ResponseData.new(@data)
      end

      def expected_response
        @expected_response
      end

      def send_error
        return handle_error(
            Mirror::Api::Errors::ERROR,
            "Error making a request for #{@resource}",
            @data
        )
      end

      def send_chosen_error
        return handle_error(
            @chosen_error,
            "Error making a request for #{@resource}",
            {:response => @error_response, :code => @error_code}
        )
      end
    end
  end
end