require "hashie/mash"

module Mirror
  module Api
    class ResponseData < Hashie::Mash
      def convert_key(key) #:nodoc:
        key.to_s.gsub(/::/, '/').
            gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
            gsub(/([a-z\d])([A-Z])/,'\1_\2').
            tr("-", "_").
            downcase
      end
    end
  end
end