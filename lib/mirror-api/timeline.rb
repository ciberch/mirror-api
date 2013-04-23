# require_relative "timeline_request"
# require_relative "timeline_item_request"

# module Mirror
#   module Api
#     class Timeline

#       def initialize(credentials)
#         @credentials =  if credentials.is_a?(String)
#           {:token => credentials}
#         elsif credentials.is_a?(Hash)
#           credentials
#         end

#         raise "Invalid credentials #{credentials.inspect}" unless @credentials
#       end

#       def list(params={})
#         TimelineRequest.new(params, 200, @credentials).get
#       end

#       def create(params)
#         TimelineRequest.new(params, 201, @credentials).post
#       end

#       def get(id, params=nil)
#         TimelineItemRequest.new(id, params, 200, @credentials).get
#       end

#       def update(id, params)
#         # This may become patch later
#         TimelineItemRequest.new(id, params, 200, @credentials).put
#       end

#       def delete(id)
#         TimelineItemRequest.new(id, nil, 200, @credentials).delete
#       end
#     end
#   end
# end

module Mirror
  class Timeline
    attr_accessor :bundleId, :canonicalUrl, :creator, :displayTime, :html, :htmlPages, :isBundleCover, :location, :menuItems, :notification, :recipients, :sourceItemId, :speakableText, :text, :title
    attr_reader :kind, :id, :selfLink, :created, :updated, :isDeleted, :etag, :inReplyTo, :attachments, :pinScore
    
    def initialize(params)
      create_instances(params)
    end

    protected
    def create_instances(data)
      data.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

  end
end

