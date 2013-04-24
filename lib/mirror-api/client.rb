require_relative "resource"

module Mirror
  module Api
    class Client

      def initialize(credentials)
        @credentials =  if credentials.is_a?(String)
                          {:token => credentials}
                        elsif credentials.is_a?(Hash)
                          credentials
                        end

        raise "Invalid credentials #{credentials.inspect}" unless @credentials
      end

      def timeline
        @timeline ||= Resource.new(@credentials)
      end

      def subscriptions
        @subscriptions ||= Resource.new(@credentials, Request::SUBSCRIPTIONS)
      end
    end
  end
end