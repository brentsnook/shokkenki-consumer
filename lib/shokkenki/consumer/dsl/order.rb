require_relative '../model/interaction'
require_relative '../model/fixture'
require_relative '../model/request'
require_relative 'http_methods'
require_relative 'term_dsl'

module Shokkenki
  module Consumer
    module DSL
      class Order
        include HttpMethods
        include TermDSL

        def initialize patronage
          @patronage = patronage
          @fixtures = []
        end

        def during label
          @interaction_label = label
          self
        end

        def receive details
          @request_details = Shokkenki::Consumer::Model::Request.new details
          self
        end

        def and_respond details
          @response_details = details
          self
        end

        def given name, arguments=nil
          @fixtures << Shokkenki::Consumer::Model::Fixture.new(
            :name => name,
            :arguments => arguments
          )
          self
        end

        def validate!
          raise "No request has been specified." unless @request_details
          raise "No response has been specified." unless @response_details
        end

        def to_interaction
          Shokkenki::Consumer::Model::Interaction.new(
            :label => @interaction_label,
            :request => @request_details,
            :response => @response_details,
            :fixtures => @fixtures
          )
        end

        def to &block
          # allows caller context and order to both be referenced from block
          # see http://www.dan-manges.com/blog/ruby-dsls-instance-eval-with-delegation (instance_eval + delegation)
          @caller_context = eval 'self', block.binding

          instance_eval &block
          validate!
          @patronage.add_interaction to_interaction
        end

        def method_missing(method, *args, &block)
          @caller_context.send method, *args, &block
        end
      end
    end
  end
end