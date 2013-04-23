require 'forwardable'
class TimelineArray
  include Enumerable
  extend Forwardable
  def_delegators :@array, :each, :<<
  def initialize(nextPageToken=nil)
    @nextPageToken = nextPageToken
    @array = []
  end
end