module Mirror
  module Api
    class Timeline < Mirror::Api::Base

      def invoke_url
        @invoke_url ||="#{self.host}/mirror/v1/timeline"
      end

      def params
        @params
      end

      def successful_response?
        @response and @response.code == 201
      end
    end
  end
end