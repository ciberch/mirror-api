require_relative "resource"

module Mirror
  module Api
    class Client

      attr_accessor :credentials, :options

      def initialize(credentials, options={raise_errors: false})
        self.credentials = credentials
        self.options = options
        raise "Invalid credentials. Missing token" unless (self.credentials && self.credentials[:token])
      end

      def credentials=(value)
        if value.is_a?(String)
          @credentials =  {:token => value}
        elsif value.is_a?(Hash)
          @credentials = value
        end
      end

      def timeline
        @timeline ||= Resource.new(credentials, Request::TIMELINE, options)
      end

      def subscriptions
        @subscriptions ||= Resource.new(credentials, Request::SUBSCRIPTIONS, options)
      end

      def locations
        @locations ||= Resource.new(credentials, Request::LOCATIONS, options)
      end

      def contacts
        @contacts ||= Resource.new(credentials, Request::CONTACTS, options)
      end
    end
  end
end