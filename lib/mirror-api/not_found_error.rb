module Mirror
  module Api
    class NotFoundError < RuntimeError

      attr :details, :error

      def initialize(error, details)
        @error = error
        @details = details
      end

    end
  end
end
