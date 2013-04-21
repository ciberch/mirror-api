require "rspec"
require 'webmock/rspec'
require 'webmock'

require_relative "../lib/mirror-api/timeline.rb"

def load_fixture(filename)
  File.read("#{File.dirname(__FILE__)}/fixtures/#{filename}")
end