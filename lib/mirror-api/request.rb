require_relative "base"

module Mirror
  module Api
    HOST = "https://www.googleapis.com"

    class Request < Mirror::Api::Base
      TIMELINE = "timeline"
      SUBSCRIPTIONS = "subscriptions"
      LOCATIONS = "locations"

      def initialize(creds, options={})
        @resource = options[:resource] || TIMELINE
        @id = options[:id]
        @params = options[:params]
        @expected_response = options[:expected_response]
        host = options[:host] || HOST
        super(creds, options[:raise_errors], host, options[:logger])
      end

      def invoke_url
        @invoke_url ||="#{self.host}/mirror/v1/#{@resource}/#{@id ? @id : ''}"
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