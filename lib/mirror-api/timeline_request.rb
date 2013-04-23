require_relative 'timeline_array'
require_relative 'timeline'
module Mirror
  module TimelineRequest
    def insert_timeline(params)
      begin
        result = post({params: params, invoke_url: "#{Mirror.endpoint}/timeline"})
        Timeline.new(result) unless result.nil?
      rescue => e
        raise e
      end
    end

    def list_timelines(params={})
      parameters = params.map {|param| "#{param[0]}=#{param[1]}"}.join('&')
      encoded_parameters = URI.encode(parameters)
      invoke_url = encoded_parameters.empty? ? "#{Mirror.endpoint}/timeline" : "#{Mirror.endpoint}/timeline?#{encoded_parameters}"
      result = get({invoke_url: "#{Mirror.endpoint}/timeline"})
      timeline_array = TimelineArray.new(result['nextPageToken'])
      result['items'].each {|item| timeline_array << Timeline.new(item) }
      timeline_array
    end
  end
end
