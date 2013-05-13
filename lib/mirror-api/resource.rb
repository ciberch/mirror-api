require_relative "request"

module Mirror
  module Api
    class Resource

      attr_accessor :options

      def initialize(credentials, resource_name=Request::TIMELINE, options={})
        @credentials =  credentials
        @resource_name = resource_name
        self.options = options || {}

        raise "Invalid credentials #{credentials}" unless @credentials
      end

      def list(*args)
        handle_list(args)
      end

      def create(params, attachment=nil)
        if attachment
          insert_media(params, attachment)
        else
          Request.new(@credentials, make_options(params)).post
        end
      end
      alias insert create

      def insert_media(params, attachment)
        Request.new(@credentials, make_options(params)).multipart_post(attachment)
      end

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
        options.merge({
            :resource => @resource_name,
            :params => params,
            :expected_response => status
        })
      end

      def item_options(id, params=nil, status=200)
        options.merge({
            :resource => @resource_name,
            :id => id,
            :params => params,
            :expected_response => status
        })
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
