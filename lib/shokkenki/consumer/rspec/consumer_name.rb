module Shokkenki
  module Consumer
    module RSpec
      class ConsumerName

        def self.from example
          metadata = example.metadata
          consumer_metadata = metadata[:shokkenki_consumer]
          consumer_metadata == true ? description_arg_from(metadata): consumer_metadata
        end

        private

        def self.description_arg_from metadata
          example_group_metadata = metadata[:example_group]
          while(example_group_metadata.has_key?(:parent_example_group)) do
            example_group_metadata = example_group_metadata[:parent_example_group]
          end

          example_group_metadata[:description_args].first
        end

      end
    end
  end
end