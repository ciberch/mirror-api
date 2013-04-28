require "hashie/mash"

module Mirror
  module Api
    class RequestData < Hashie::Mash
      def convert_key(key) #:nodoc:
        key.to_s.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
      end
    end
  end
end