module Mirror
  module Api
    class Errors
      ERROR_400 = {code: 1, :message => "Mirror API returned a status code 400 for this call"}
      ERROR_404 = {code: 2, :message => "Mirror API returned a status code 404 for this call"}
      INTERNAL_ERROR = {:code => 100, :message => "We are experiencing problems requesting your name. Our team has been notified."}
      TOKEN_REFRESH_ERROR = {:code => 200, :message => "Could not refresh your API access token"}
    end
end
end