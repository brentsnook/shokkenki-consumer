module Shokkenki
  module Consumer
    module RSpec
      class ConsumerName

        def self.from example_group
          metadata = example_group.example.metadata
          consumer_metadata = metadata[:shokkenki_consumer]
          consumer_metadata == true ? description_arg_from(metadata): consumer_metadata
        end

        private

        def self.description_arg_from metadata
          while(metadata.has_key?(:example_group)) do
            metadata = metadata[:example_group]
          end

          metadata[:description_args].first
        end

      end
    end
  end
end