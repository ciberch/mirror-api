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

