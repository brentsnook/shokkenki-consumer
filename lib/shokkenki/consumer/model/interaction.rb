module Shokkenki
  module Consumer
    module Model
      class Interaction

        attr_reader :label, :request, :response, :time, :fixtures

        def initialize attributes
          @request = attributes[:request]
          @label = attributes[:label] || @request.label
          @response = attributes[:response]
          @fixtures = attributes[:fixtures]
          @time = Time.now
        end

        def to_hash
          hash = {
            :request => @request.to_hash,
            :response => @response.to_hash,
            :time => @time.utc.iso8601,
            :label => @label
          }
          hash.merge!(:fixtures => @fixtures.map{ |f| f.to_hash }) if @fixtures
          hash
        end
      end
    end
  end
end