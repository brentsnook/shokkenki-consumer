require_relative '../../../spec_helper'
require 'shokkenki/consumer/rspec/example_group_binding'
require 'shokkenki/consumer/rspec/hooks'

describe 'RSpec configuration' do

  let(:config) { double('RSpec configuration', :before => '', :after => '').as_null_object }
  let(:load_config) { load 'shokkenki/consumer/rspec/rspec_configuration.rb' }
  let(:session) { double('Shokkenki session').as_null_object }

  before do
    @filtered_to_consumer_examples = false
    allow(config).to receive(:include).with(Shokkenki::Consumer::RSpec::ExampleGroupBinding, anything) do |scope, filter|
      @filtered_to_consumer_examples = filter[:shokkenki_consumer].call ''
    end
  end

  let(:hooks) { Shokkenki::Consumer::RSpec::Hooks }

  before do
    allow(::RSpec).to receive(:configure).and_yield(config)
    allow(Shokkenki).to receive(:consumer).and_return session
    allow(hooks).to receive(:around)
    allow(hooks).to receive(:before_suite)
    allow(hooks).to receive(:after_suite)
  end

  it 'includes the example group binding to make the DSL available' do
    load_config
    expect(config).to have_received(:include).with(Shokkenki::Consumer::RSpec::ExampleGroupBinding, anything)
  end

  # we want to avoid defining methods on the example group unless we have to.
  # this lessens the chance of a collision with something else
  it 'only makes the DSL available to shokkenki consumer examples' do
    load_config
    expect(@filtered_to_consumer_examples).to eq(true)
  end

  context 'around each example' do

    let(:example) { double :example }

    before do
      # simulating what happens with an example group
      # sucks, need a better way to test this
      @filtered_to_consumer_examples = false
      allow(config).to receive(:around).with(:example, anything) do |scope, filter, &block|
        block.call example
        @filtered_to_consumer_examples = filter[:shokkenki_consumer].call ''
      end
    end

    before { load_config }

    it 'only runs the hook for shokkenki consumer examples' do
      expect(@filtered_to_consumer_examples).to eq(true)
    end

    it 'runs the before each hook with the example group' do
      expect(hooks).to have_received(:around).with(example)
    end

  end

  context 'before the test suite begins' do
    before do
      allow(config).to receive(:before).with(:suite).and_yield
      load_config
    end

    it 'runs the before suite hook' do
      expect(hooks).to have_received(:before_suite)
    end

  end

  context 'after the test suite finishes' do

    before do
      allow(config).to receive(:after).with(:suite).and_yield
      load_config
    end

    it 'runs the after suite hook' do
      expect(hooks).to have_received(:after_suite)
    end
  end

  context 'when the RSpec version supports backtrace inclusion patterns' do
    let(:patterns) { double('patterns').as_null_object }

    before do
      allow(config).to receive(:backtrace_inclusion_patterns).and_return patterns
      load_config
    end

    it 'includes shokkenki-provider lines in the backtrace' do
      expect(patterns).to have_received(:<<).with(/shokkenki\-consumer/)
    end
  end

  context "when the RSpec version doesn't support backtrace inclusion patterns" do
    let(:patterns) { double('patterns').as_null_object }

    before do
      load_config
    end

    it "doesn't attempt to add any patterns for exclusion" do
      expect(patterns).to_not have_received(:backtrace_inclusion_patterns)
    end
  end
end