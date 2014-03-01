require_relative '../../../spec_helper'
require 'shokkenki/consumer/model/request'

describe Shokkenki::Consumer::Model::Request do

  let(:request_attributes) { {:method => :get, :path => '/path'} }
  subject { Shokkenki::Consumer::Model::Request.new request_attributes }

  context 'when created' do

    context 'when the request method is not present' do
      before do
        request_attributes.delete(:method)
      end

      it 'fails' do
        expect { subject }.to raise_error("No request method has been specified.")
      end

    end

    context 'when the request method is not a symbol' do
      before do
        request_attributes[:method] = /get/
      end

      it 'fails' do
        expect { subject }.to raise_error("The request method must be a symbol.")
      end

    end

    context 'when the request path is not present' do
      before do
        request_attributes.delete(:path)
      end

      it 'fails' do
        expect { subject }.to raise_error("No request path has been specified.")
      end

    end

    context 'when the request path is not a string' do
      before do
        request_attributes[:path] = /path/
      end

      it 'fails' do
        expect { subject }.to raise_error("The request path must be a string.")
      end

    end
  end

  describe 'label' do
    it 'includes method and path' do
      expect(subject.label).to match(/^get \/path/)
    end

    context 'when there is a query' do
      before do
        request_attributes[:query] = {:'query-param' => 'value'}
      end

      it 'includes the query' do
        expect(subject.label).to match(/ \? {"query-param":"value"}/)
      end
    end

    context 'when there are headers ' do
      before do
        request_attributes[:headers] = {:'content-type' => 'application/json'}
      end

      it 'includes the headers' do
        expect(subject.label).to match(/ headers: {"content-type":"application\/json"}/)
      end
    end
  end
end
