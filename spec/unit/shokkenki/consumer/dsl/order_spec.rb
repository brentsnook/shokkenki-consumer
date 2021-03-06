require_relative '../../../spec_helper'
require 'shokkenki/consumer/dsl/order'
require 'shokkenki/consumer/model/interaction'
require 'shokkenki/consumer/model/fixture'

describe Shokkenki::Consumer::DSL::Order do

  let(:response_attributes) { double('response attributes').as_null_object }
  let(:request_attributes) { {:method => :get, :path => '/path'} }
  let(:patronage) { double('patronage').as_null_object }

  subject { Shokkenki::Consumer::DSL::Order.new patronage }

  before do
    allow(Shokkenki::Consumer::Model::Interaction).to receive(:new)
  end

  it 'includes HTTP methods' do
    expect(subject).to respond_to(:put)
  end

  it 'includes term DSL' do
    expect(subject).to respond_to(:json)
  end

  context 'to' do

    before do
      subject.receive request_attributes
      subject.and_respond response_attributes
    end

    let(:interaction) { double 'interaction' }
    let(:caller_context) { double('calling context').as_null_object }

    before do
      allow(subject).to receive(:validate!)
      allow(subject).to receive(:set_details)
      allow(subject).to receive(:to_interaction).and_return interaction

      subject.to { set_details }
    end

    it 'allows the details of the order to be collected' do
      expect(subject).to have_received(:set_details)
    end

    it 'validates the order' do
      expect(subject).to have_received(:validate!)
    end

    it 'adds the resulting interaction to the patronage' do
      expect(patronage).to have_received(:add_interaction).with(interaction)
    end

    # this is useful for referring to RSpec let variables for example
    # we need access to the caller context to allow lets to be lazily evaluated
    it 'allows the order to refer to the caller context' do
      subject.to { caller_context.some_method }
      expect(caller_context).to have_received(:some_method)
    end

  end

  context 'given' do

    before do
      subject.receive request_attributes
      subject.and_respond response_attributes
    end

    let(:request_term) { double 'request term' }
    let(:fixture) { double 'fixture' }
    let(:order_with_given) { subject.given :fixture_name, {:fixture => :arguments} }

    before do
      allow(Shokkenki::Consumer::Model::Fixture).to(
        receive(:new).with(:name => :fixture_name, :arguments => {:fixture => :arguments}).
        and_return(fixture)
      )
    end

    it 'defines the fixture of the interaction' do
      order_with_given.to_interaction
      expect(Shokkenki::Consumer::Model::Interaction).to have_received(:new).with(hash_including(:fixtures => [fixture]))
    end

    it 'allows order calls to be chained' do
      expect(order_with_given).to be(subject)
    end

  end

  context 'during' do
    let(:order_with_label) { subject.during 'my label' }

    before do
      subject.receive request_attributes
      subject.and_respond response_attributes
    end

    it 'defines the label of the interaction' do
      order_with_label.to_interaction
      expect(Shokkenki::Consumer::Model::Interaction).to have_received(:new).with(hash_including(:label => 'my label'))
    end

    it 'allows order calls to be chained' do
      expect(order_with_label).to be(subject)
    end
  end

  context 'receive' do

    let(:request_term) { double 'request term' }

    let(:order_with_request) { subject.receive request_attributes }
    let(:request) { double('request') }

    before do
      subject.receive request_attributes
      subject.and_respond response_attributes
    end

    before do
      allow(Shokkenki::Consumer::Model::Request).to receive(:new).and_return request
    end

    context 'when a valid request has been specified' do

      it 'defines the request of the interaction using a term' do
        order_with_request.to_interaction
        expect(Shokkenki::Consumer::Model::Interaction).to have_received(:new).with(hash_including(:request => request))
      end

      it 'allows order calls to be chained' do
        expect(order_with_request).to be(subject)
      end
    end
  end

  context 'and respond' do
    let(:order_with_response) { subject.and_respond response_attributes }

    before do
      subject.receive request_attributes
      subject.and_respond response_attributes
    end

    it 'defines the response of the interaction using a term' do
      order_with_response.to_interaction
      expect(Shokkenki::Consumer::Model::Interaction).to have_received(:new).with(hash_including(:response => response_attributes))
    end

    it 'allows order calls to be chained' do
      expect(order_with_response).to be(subject)
    end
  end

  context 'validation' do

    context "when 'requested with' has not been specified" do

      before do
        subject.and_respond response_attributes
      end

      it 'fails' do
        expect { subject.validate! }.to raise_error("No request has been specified.")
      end
    end

    context "when 'and respond' has not been specified" do

      before do
        subject.receive request_attributes
      end

      it 'fails' do
        expect { subject.validate! }.to raise_error("No response has been specified.")
      end
    end
  end
end