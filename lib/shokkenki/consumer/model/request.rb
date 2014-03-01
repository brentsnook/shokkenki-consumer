module Shokkenki
  module Consumer
    module Model
      class Request < Hash

        def initialize attributes
          raise "No request method has been specified." unless attributes.has_key?(:method)
          raise "The request method must be a symbol." unless attributes[:method].is_a?(Symbol)

          raise "No request path has been specified." unless attributes.has_key?(:path)
          raise "The request path must be a string." unless attributes[:path].is_a?(String)
          merge! attributes
        end

        def label
          query = " ? #{self[:query].to_json}" if self[:query]
          headers = " headers: #{self[:headers].to_json}" if self[:headers]
          "#{self[:method]} #{self[:path]}#{query}#{headers}"
        end

      end
    end
  end
end


