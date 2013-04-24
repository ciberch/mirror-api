require 'forwardable'
class TimelineArray
  include Enumerable
  extend Forwardable
  attr_reader :nextPageToken
  def_delegators :@array, :each, :<<
  def initialize(nextPageToken=nil)
    @nextPageToken = nextPageToken
    @array = []
  end
end