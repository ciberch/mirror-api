module Mirror
  module Api
    class BadRequestError < RuntimeError

      attr :details, :error

      def initialize(error, details)
        @error = error
        @details = details
      end

    end
  end
end