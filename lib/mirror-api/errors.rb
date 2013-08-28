require_relative "not_found_error"
require_relative "bad_request_error"

module Mirror
  module Api
    class Errors
      ERROR_400 = {code: 1, :message => "Mirror API returned a status code 400 for this call", :ex_class => Mirror::Api::BadRequestError}
      ERROR_404 = {code: 2, :message => "Mirror API returned a status code 404 for this call", :ex_class => Mirror::Api::NotFoundError}
      ERROR = {:code => 100, :message => "Mirror API returned an unexpected status code"}
      TOKEN_REFRESH_ERROR = {:code => 200, :message => "Could not refresh your API access token"}
    end
end
end