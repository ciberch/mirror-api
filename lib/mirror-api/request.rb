require_relative "base"

module Mirror
  module Api
    HOST = "https://www.googleapis.com"

    class Request < Mirror::Api::Base
      TIMELINE = "timeline"
      SUBSCRIPTIONS = "subscriptions"
      LOCATIONS = "locations"
      CONTACTS = "contacts"

      def initialize(creds, options={})
        @resource = options[:resource] || TIMELINE
        @id = options[:id]
        @params = options[:params]
        @expected_response = options[:expected_response]
        host = options[:host] || HOST
        throw_on_fail = options[:raise_errors] || false
        super(creds, throw_on_fail, host, options[:logger])
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