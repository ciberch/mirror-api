require_relative "request"

module Mirror
  module Api
    class Resource

      def initialize(credentials, resource_name=Request::TIMELINE)
        @credentials =  credentials
        @resource_name = resource_name

        raise "Invalid credentials #{credentials}" unless @credentials
      end

      def list(*args)
        handle_list(args)
        
      end

      def create(params)
        Request.new(@credentials, make_options(params)).post
      end
      alias insert create

      def get(id, params=nil)
        Request.new(@credentials, item_options(id, params)).get
      end

      def update(id, params)
        # This may become patch later
        Request.new(@credentials, item_options(id, params)).put
      end

      def patch(id, params)
        Request.new(@credentials, item_options(id, params)).patch
      end

      def delete(id, params=nil)
        Request.new(@credentials, item_options(id, params)).delete
      end

    private
      def make_options(params=nil, status=200)
        {:resource => @resource_name, :params => params, :expected_response => status}
      end

      def item_options(id, params=nil, status=200)
        {:resource => @resource_name, :id => id, :params => params, :expected_response => status}
      end

      def handle_list(args)
        if args.first.is_a?(String)
          Request.new(@credentials, item_options(args[0], args[1])).get
        else
          Request.new(@credentials, make_options(args[0])).get
        end
      end

    end
  end
end
