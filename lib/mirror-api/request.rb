require "rest-client"
require "json"
require_relative "response"
require_relative "errors"

module Mirror
  module Api
    HOST = "https://www.googleapis.com"

    class Request
      TIMELINE = "timeline"
      SUBSCRIPTIONS = "subscriptions"
      LOCATIONS = "locations"
      CONTACTS = "contacts"

      attr_accessor :last_error, :logger, :host, :last_exception, :throw_on_fail, :response, :data, :creds


      def initialize(creds, options={})
        @resource = options[:resource] || TIMELINE
        @id = options[:id]
        @params = options[:params]
        @expected_response = options[:expected_response]

        @creds = creds
        @last_exception = nil
        @throw_on_fail = options[:raise_errors] || false
        @host = options[:host] || HOST
        @logger = options[:logger]
        @last_error = nil
      end

      public
      def post(json=false)
        do_verb(:post, json)
      end

      def put(json=false)
        do_verb(:put, json)
      end

      def patch(json=false)
        do_verb(:patch, json)
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
          when 404
          when 400
            if @logger
              msg = "ERROR - #{response.code} #{request.inspect} to #{self.invoke_url} with params #{self.params}. Response is #{response.body}"
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

      def set_data
        if @response and @response.body
          @data = JSON.parse(@response.body) if @response.body.is_a?(String) && !@response.body.empty?
        end
      end

      def do_verb(verb=:post, json=false)
        data = json ? self.params : self.params.to_json
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
        params[:attachments] if params
      end

      def params
        @params ||={}
      end

      def ret_val
        Response.new(@data)
      end

      def expected_response
        @expected_response
      end

      def send_error
        return handle_error(
            Mirror::Api::Errors::ERROR_400,
            "Error making a request for #{@resource}",
            @data
        )
      end
    end
  end
end