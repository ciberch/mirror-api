module Mirror
  module TimelineRequest
    def insert(params)
      begin
        result = API.new(params: params, expected_response: 200, invoke_url: "#{Mirror.endpoint}/timeline").post
        Timeline.new(result) unless result.nil?
      rescue => e
        raise e
      end
    end

    def list(params={})
      parameters = params.map {|param| "#{param[0]}=#{param[1]}"}.join('&')
      encoded_parameters = URI.encode(parameters)
      invoke_url = encoded_parameters.empty? ? "#{Mirror.endpoint}/timeline" : "#{Mirror.endpoint}/timeline?#{encoded_parameters}"
      result = API.new(expected_response: 200, invoke_url: "#{Mirror.endpoint}/timeline").get
      timeline_array = TimelineArray.new(result['nextPageToken'])
      result['items'].each {|item| timeline_array << Timeline.new(item) }
      timeline_array
    end
  end
end
