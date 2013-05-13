require 'simplecov'
SimpleCov.start
require "rspec"
require 'webmock/rspec'
require 'webmock'
require 'pry'

require_relative "../lib/mirror-api/client.rb"
require_relative "../lib/mirror-api/oauth.rb"

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file, read=false)
  file = File.new(fixture_path + '/' + file)
  return File.read(file) if read
  file
end

def json_post_request_headers(token, body)
  {
      'Accept'=>'application/json',
      'Accept-Encoding'=>'gzip, deflate',
      'Authorization'=>"Bearer #{token}",
      'Content-Length'=>body.length.to_s,
      'Content-Type'=>'application/json',
      'User-Agent'=>'Ruby'
  }
end

def json_get_request_headers(token)
  {
      'Accept'=>'application/json',
      'Accept-Encoding'=>'gzip, deflate',
      'Authorization'=>"Bearer #{token}",
      'Content-Type'=>'application/json',
      'User-Agent'=>'Ruby'
  }
end