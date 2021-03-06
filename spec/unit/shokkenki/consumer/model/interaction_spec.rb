require_relative '../../../spec_helper'
require 'timecop'
require 'shokkenki/consumer/model/interaction'

describe Shokkenki::Consumer::Model::Interaction do

  let(:request) { double 'request', :label => 'request label', :to_shokkenki_term => request_term }
  let(:response) { double 'response', :to_shokkenki_term => response_term }

  context 'when created' do

    let(:request_term) { double('request term') }
    let(:response_term) { double('response term') }
    let(:current_time) { Time.now }
    let(:fixture) { double 'fixture' }

    subject do
      Timecop.freeze(current_time) do
        Shokkenki::Consumer::Model::Interaction.new(
          :label => 'interaction label',
          :request => request,
          :response => response,
          :fixtures => [fixture]
        )
      end
    end

    context 'when given no label' do
      subject do
        Shokkenki::Consumer::Model::Interaction.new(
          :request => request,
          :response => response,
          :fixtures => [fixture]
        )
      end

      it 'generates a label from the request' do
        expect(subject.label).to eq('request label')
      end
    end

    it 'has a the given label' do
      expect(subject.label).to eq('interaction label')
    end

    it 'has the given request, coerced into a shokkenki term' do
      expect(subject.request).to eq(request_term)
    end

    it 'has the given response, coerced into a shokkenki term' do
      expect(subject.response).to eq(response_term)
    end

    it 'has the current time' do
      expect(subject.time).to eq(current_time)
    end

    it 'has the given fixtures' do
      expect(subject.fixtures).to eq([fixture])
    end
  end

  context 'converted to a hash' do
    let(:request_term) { double 'request', :to_hash => {'request' => 'hash'} }
    let(:response_term) { double 'response', :to_hash => {'response' => 'hash'} }
    let(:fixture) { double 'fixture', :to_hash => {'fixture' => 'hash'} }
    let(:current_time) { Time.parse '2012-04-23T18:25:43Z' }

    let(:label) { 'interaction label' }
    let(:fixtures) { [fixture] }

    subject do
      Timecop.freeze(current_time) do
        Shokkenki::Consumer::Model::Interaction.new(
          :label => label,
          :request => request,
          :response => response,
          :fixtures => fixtures
        )
      end
    end

    it 'includes the label' do
      expect(subject.to_hash[:label]).to eq('interaction label')
    end

    it 'includes the request hash' do
      expect(subject.to_hash[:request]).to eq({'request' => 'hash'})
    end

    it 'includes the response hash' do
      expect(subject.to_hash[:response]).to eq({'response' => 'hash'})
    end

    it 'includes the time formatted as an ISO 8601 date' do
      expect(subject.to_hash[:time]).to eq('2012-04-23T18:25:43Z')
    end

    context 'when there are fixtures' do
      it 'includes the fixtures as a hash' do
        expect(subject.to_hash[:fixtures]).to eq([{'fixture' => 'hash'}])
      end
    end

    context 'when there are no fixtures' do
      let(:fixtures) { nil }
      it 'does not include the fixtures hash' do
        expect(subject.to_hash).to_not have_key(:fixtures)
      end
    end
  end

end