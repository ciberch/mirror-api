require_relative "base"

module Mirror
  module Api
    class Timeline < Mirror::Api::Base

      def initialize(params, creds, raise_errors, host="https://www.googleapis.com", logger=nil)
        @params = params
        super(creds, raise_errors)
      end

      def invoke_url
        @invoke_url ||="#{self.host}/mirror/v1/timeline"
      end

      def params
        @params ||={}
      end

      def ret_val
        Hashie::Mash.new(@data)
      end

      def successful_response?
        @response and @response.code == 201
      end
    end
  end
end