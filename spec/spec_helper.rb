require 'simplecov'
SimpleCov.start
require "rspec"
require 'webmock/rspec'
require 'webmock'

require_relative "../lib/mirror-api/client.rb"

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file, read=false)
  file = File.new(fixture_path + '/' + file)
  return File.read(file) if read
  file
end