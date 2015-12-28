require_relative 'example_group_binding'
require_relative 'hooks'
require 'rspec'

RSpec.configure do |config|
  if config.respond_to?(:backtrace_inclusion_patterns)
    config.backtrace_inclusion_patterns << /shokkenki\-consumer/
  end

  config.include(
    Shokkenki::Consumer::RSpec::ExampleGroupBinding,
    :shokkenki_consumer => lambda{ |x| true }
  )

  config.before(:suite) { Shokkenki::Consumer::RSpec::Hooks.before_suite }

  shokkenki_consumer_examples = { :shokkenki_consumer => lambda{ |x| true } }

  config.around(:example, shokkenki_consumer_examples) do |example|
    Shokkenki::Consumer::RSpec::Hooks.around example
  end

  config.after(:suite) { Shokkenki::Consumer::RSpec::Hooks.after_suite }
end