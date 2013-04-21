require_relative "timeline_request"
require_relative "timeline_item_request"

module Mirror
  module Api
    class Timeline

      def initialize(credentials)
        @credentials =  if credentials.is_a?(String)
          {:token => credentials}
        elsif credentials.is_a?(Hash)
          credentials
        end

        raise "Invalid credentials #{credentials.inspect}" unless @credentials
      end

      def list(params={})
        TimelineRequest.new(params, 200, @credentials).get
      end

      def create(params)
        TimelineRequest.new(params, 201, @credentials).post
      end

      def get(id, params=nil)
        TimelineItemRequest.new(id, params, 200, @credentials).get
      end

      def update(id, params)
        # This may become patch later
        TimelineItemRequest.new(id, params, 200, @credentials).put
      end

      def delete(id)
        TimelineItemRequest.new(id, nil, 200, @credentials).delete
      end
    end
  end
end
