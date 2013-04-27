require_relative "resource"

module Mirror
  module Api
    class Client

      attr_reader :credentials, :raise_errors

      def initialize(credentials, raise_errors=false)
        @credentials =  if credentials.is_a?(String)
                          {:token => credentials}
                        elsif credentials.is_a?(Hash)
                          credentials
                        end
        @raise_errors = raise_errors
        raise "Invalid credentials. Missing token" unless (@credentials && @credentials[:token])
      end

      def timeline
        @timeline ||= Resource.new(@credentials, Request::TIMELINE, raise_errors)
      end

      def subscriptions
        @subscriptions ||= Resource.new(@credentials, Request::SUBSCRIPTIONS, raise_errors)
      end

      def locations
        @locations ||= Resource.new(@credentials, Request::LOCATIONS, raise_errors)
      end

      def contacts
        @contacts ||= Resource.new(@credentials, Request::CONTACTS, raise_errors)
      end
    end
  end
end