require_relative "resource"

module Mirror
  module Api
    class Client

      attr_reader :credentials

      def initialize(credentials)
        @credentials =  if credentials.is_a?(String)
                          {:token => credentials}
                        elsif credentials.is_a?(Hash)
                          credentials
                        end

        raise "Invalid credentials. Missing token" unless (@credentials && @credentials[:token])
      end

      def timeline
        @timeline ||= Resource.new(@credentials)
      end

      def subscriptions
        @subscriptions ||= Resource.new(@credentials, Request::SUBSCRIPTIONS)
      end

      def locations
        @locations ||= Resource.new(@credentials, Request::LOCATIONS)
      end

      def contacts
        @contacts ||= Resource.new(@credentials, Request::CONTACTS)
      end
    end
  end
end