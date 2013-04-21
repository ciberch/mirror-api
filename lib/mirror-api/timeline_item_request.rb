require_relative "base"

module Mirror
  module Api
    HOST = "https://www.googleapis.com"

    class TimelineItemRequest < Mirror::Api::Base

      def initialize(id, params, expected_response, creds, raise_errors=false, host=Mirror::Api::HOST, logger=nil)
        @id = id
        @params = params
        @expected_response = expected_response
        super(creds, raise_errors)
      end

      def invoke_url
        @invoke_url ||="#{self.host}/mirror/v1/timeline/#{@id}"
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