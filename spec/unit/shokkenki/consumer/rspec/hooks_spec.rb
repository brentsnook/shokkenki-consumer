require_relative '../../../spec_helper'
require 'shokkenki/consumer/rspec/hooks'
require 'shokkenki/consumer/rspec/consumer_name'
require 'shokkenki/consumer/model/role'
require 'shokkenki/consumer/consumer'

describe Shokkenki::Consumer::RSpec::Hooks do

  subject { Shokkenki::Consumer::RSpec::Hooks }

  let(:session) { double('Shokkenki session').as_null_object }

  before do
    allow(Shokkenki).to receive(:consumer).and_return session
  end

  let(:existing_consumer) { nil }

  context 'around each example' do
    let(:example) { double :example, run: nil }
    let(:role) { double 'role' }
    let(:existing_consumer) { double 'existing consumer' }

    before do
      allow(Shokkenki::Consumer::RSpec::ConsumerName).to(
        receive(:from).and_return(:consumername)
      )

      allow(session).to receive(:consumer).and_return existing_consumer
      allow(Shokkenki::Consumer::Model::Role).to receive(:new).and_return(role)

      subject.around example
    end

    it 'attempts to find the existing consumer' do
      expect(session).to have_received(:consumer).with(:consumername)
    end

    it 'extracts the consumer name from the example' do
      expect(Shokkenki::Consumer::RSpec::ConsumerName).to have_received(:from).with(example)
    end

    context 'regardless of whether consumer exists' do

      # this allows an implicit consumer to be referred to in the DSL
      it 'sets a new consumer using the name extracted from the example group' do
        expect(session).to have_received(:set_current_consumer).with :consumername
      end

      it 'clears interaction stubs in the session' do
        expect(session).to have_received(:clear_interaction_stubs)
      end
    end

    context 'when no consumer exists with the given name' do
      let(:existing_consumer) { nil }

      it 'creates a new role' do
        expect(Shokkenki::Consumer::Model::Role).to have_received(:new).with(:name => :consumername)
      end

      it 'adds the new role as consumer' do
        expect(session).to have_received(:add_consumer).with(role)
      end
    end

    it 'runs the example' do
      expect(example).to have_received(:run)
    end

    it 'asserts that no provider had unmatched requests' do
      expect(session).to have_received(:assert_all_requests_matched!)
    end

    it 'asserts that no provider had unused interactions' do
      expect(session).to have_received(:assert_all_interactions_used!)
    end

  end

  context 'before the test suite begins' do
    before { subject.before_suite }

    it 'starts the session' do
      expect(session).to have_received(:start)
    end

  end

  context 'after the test suite finishes' do

    before { subject.after_suite }

    it 'prints out all tickets' do
      expect(session).to have_received(:print_tickets)
    end

    it 'closes the session' do
      expect(session).to have_received(:close)
    end
  end
end