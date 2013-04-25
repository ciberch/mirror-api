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
        super(creds, options[:raise_errors], host, options[:logger])
      end

      def invoke_url
        return @invoke_url unless @invoke_url.nil?
        @invoke_url ="#{self.host}/mirror/v1/#{@resource}/#{@id ? @id : ''}"
        @invoke_url += "/attachments/#{attachment_id ? attachment_id : ''}" if attachments
        @invoke_url
      end

      def attachment_id
        if attachments
          if params[:attachments][:id]
            @attachment_id ||= params[:attachments][:id]
          end
        end
      end

      def attachments
        if params[:attachments]
          @attachments ||= params[:attachments]
        end
      end

      def params
        @params ||={}
      end

      def ret_val
        Hashie::Mash.new(@data)
      end

      def expected_response
        @expected_response
      end
    end
  end
end