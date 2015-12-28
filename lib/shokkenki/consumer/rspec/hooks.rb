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

        def self.around example
          name = ConsumerName.from example
          Shokkenki.consumer.add_consumer(Shokkenki::Consumer::Model::Role.new(:name => name)) unless Shokkenki.consumer.consumer(name)
          Shokkenki.consumer.set_current_consumer name
          Shokkenki.consumer.clear_interaction_stubs

          example.run

          Shokkenki.consumer.assert_all_requests_matched!
          Shokkenki.consumer.assert_all_interactions_used!
        end

        def self.after_suite
          Shokkenki.consumer.print_tickets
          Shokkenki.consumer.close
        end
      end
    end
  end
end