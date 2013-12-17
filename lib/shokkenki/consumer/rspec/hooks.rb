require_relative '../consumer'
require_relative '../model/role'
require_relative 'consumer_name'

module Shokkenki
  module Consumer
    module RSpec
      class Hooks

        def self.before_suite
          Shokkenki.consumer.start
        end

        def self.before_each example_group
          name = ConsumerName.from example_group
          Shokkenki.consumer.add_consumer(Shokkenki::Consumer::Model::Role.new(:name => name)) unless Shokkenki.consumer.consumer(name)
          Shokkenki.consumer.set_current_consumer name
          Shokkenki.consumer.clear_interaction_stubs
        end

        def self.after_each
          Shokkenki.consumer.assert_all_requests_matched!
          Shokkenki.consumer.assert_all_interactions_used!
        end

        def self.after_suite
          Shokkenki.consumer.print_tickets
          Shokkenki.consumer.close
        end

        private

        def self.name_from example_group
          example_group
        end

      end
    end
  end
end