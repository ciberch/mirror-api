require "hashie/mash"
require "hashie/trash"

class Response < Hashie::Trash
  property :id
  property :etag
  property :text
  property :kind
  property :created
  property :updated
  property :timestamp
  property :items
  property :source
  property :operation
  property :collection
  property :notification
  property :latitude
  property :longitude
  property :accuracy
  property :address
  property :priority

  property :obj_type, :from => :type #type is reserved
  property :display_name, :from => :displayName
  property :phone_number, :from => :phoneNumber
  property :callback_url, :from => :callbackUrl
  property :verify_token, :from => :verifyToken
  property :user_token, :from => :userToken
  property :is_processing_content, :from => :isProcessingContent
  property :accept_types, :from => :acceptTypes
  property :image_urls, :from => :imageUrls
  property :content_type, :from => :contentType
  property :content_url, :from => :contentUrl
  property :self_link, :from => :selfLink
  property :next_page_token, :from => :nextPageToken
end