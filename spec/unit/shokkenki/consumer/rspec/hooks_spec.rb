require_relative '../../../spec_helper'
require 'shokkenki/consumer/rspec/hooks'
require 'shokkenki/consumer/model/role'
require 'shokkenki/shokkenki'

describe Shokkenki::Consumer::RSpec::Hooks do

  subject { Shokkenki::Consumer::RSpec::Hooks }

  let(:session) { double('Shokkenki session').as_null_object }

  before do
    allow(Shokkenki).to receive(:consumer).and_return session
  end

  context 'before each example runs' do

    let(:metadata) { {:name => :consumername } }

    context 'regardless of whether consumer exists' do

      before { subject.before_each metadata }

      # this allows an implicit consumer to be referred to in the DSL
      it 'sets a new consumer using the shokkenki metadata' do
        expect(session).to have_received(:set_current_consumer).with :consumername
      end

      it 'clears interaction stubs in the session' do
        expect(session).to have_received(:clear_interaction_stubs)
      end
    end

    context 'when no consumer exists with the given name' do
      let(:role) { double 'role' }

      before do
        allow(session).to receive(:add_consumer)
        allow(session).to receive(:consumer).with(:consumername).and_return nil
        allow(Shokkenki::Consumer::Model::Role).to receive(:new).with(metadata).and_return(role)

        subject.before_each metadata
      end

      it 'creates the consumer' do
        expect(session).to have_received(:add_consumer).with(role)
      end

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