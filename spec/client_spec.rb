require_relative "spec_helper"

describe Mirror::Api::Client do
  before do
    @token = "my-token"
    @api = Mirror::Api::Client.new(@token)
    @api_error_bubble = Mirror::Api::Client.new(@token)
  end


end